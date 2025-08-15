@tool
extends VBoxContainer
class_name TypeColumn
@onready var type_label: Label = $TypeLabel
@onready var element_container: VBoxContainer = $ElementContainer
@onready var max_edit: SpinBox = $HBoxContainer/MaxEdit

@export var category:String = ""

@export_category("")
@export var type_row_scene:PackedScene
@export var category_index:int
@export var is_equip_type:bool = false
var max:int
var sub_types:Array = []
var quantities:Array

signal DataChanged(types:Array, i:int)
signal QuantityChanged(quantities:Array)

func _ready() -> void:
	type_label.text = category
func _save():
	var dict = {
		"name":category,
		"sub_types":sub_types
	}
	return dict

func _on_set_max_button_down() -> void:
	for child in element_container.get_children():
		element_container.remove_child(child)
		child.queue_free()
	
	var amount:int = max_edit.value
	sub_types.resize(amount)
	if is_equip_type:
		quantities.resize(amount)
	for i in amount:
		var new_type: Type = type_row_scene.instantiate()
		element_container.add_child(new_type)
		new_type.index_label.text = str(i)
		
		if sub_types[i] == null:
			sub_types[i] = ""
		new_type.line_edit.text = sub_types[i]
		
		new_type.line_edit.text_changed.connect(_update_category.bind(i))
		
		if is_equip_type:
			if quantities[i] == null:
				quantities[i] = 1
			new_type.quantity_spin_box.show()
			new_type.quantity_spin_box.value = quantities[i]
			new_type.quantity_spin_box.value_changed.connect(_update_quantity.bind(i))
		
	DataChanged.emit(sub_types, category_index)
	QuantityChanged.emit(quantities)
	
	
func _update_category(text:String, index:int):
	sub_types[index] = text
	DataChanged.emit(sub_types, category_index)

func _update_quantity(value:int, index:int):
	quantities[index] = value
	for i in range(quantities.size()):
		if quantities[i] == null:
			quantities[i] = 1
	QuantityChanged.emit(quantities)

#sent down from parent on loading
func _on_types_editor_load_quantities(_quantities: Variant) -> void:
	quantities = _quantities
