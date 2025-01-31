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
var max:int
var sub_types:Array = []

signal DataChanged(types:Array, i:int)


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
	for i in amount:
		var new_type: Type = type_row_scene.instantiate()
		element_container.add_child(new_type)
		new_type.index_label.text = str(i)
		
		if sub_types[i] == null:
			sub_types[i] = ""
		new_type.line_edit.text = sub_types[i]
		
		new_type.line_edit.text_changed.connect(_update_category.bind(i))
	DataChanged.emit(sub_types, category_index)
	
	
func _update_category(text:String, index:int):
	sub_types[index] = text
	DataChanged.emit(sub_types, category_index)
