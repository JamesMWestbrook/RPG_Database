extends Control
class_name Items

#region
@onready var items_box: VBoxContainer = $"ScrollContainer/BoxContainer/1st Column/ScrollContainer/ItemsBox"
@onready var item_count_spinbox: SpinBox = $"ScrollContainer/BoxContainer/1st Column/HBoxContainer2/ItemCountSpinbox"

#this time around we are doing exports for most of the stuff, that way if stuff gets moved around, it won't
#make things break
@export var name_edit:LineEdit
@export var desc_edit:TextEdit
@export var texture:TextureRect
@export var item_type_button:OptionButton
@export var price_box:SpinBox
@export var consumable_button:OptionButton
@export var scope_option_button:OptionButton
@export var number_option_button:OptionButton
@export var random_spin_box:SpinBox
@export var occaision_option_button:OptionButton
@export var animation_option_button:OptionButton

@export var speed_spin_box:SpinBox
@export var success_spin_box:SpinBox
@export var repeat_spin_box:SpinBox
@export var tp_gain_spin_box:SpinBox

@export var damage_type_option_button:OptionButton
@export var element_type_option_button:OptionButton
@export var formula_editor:CodeEdit
@export var notes_edit:TextEdit
#endregion

var cur_item_index:int
static var items:Array
const JSON_SAVE_PATH = "res://data/items.json"

signal ItemsUpdated(items)
func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_item_buttons()
	_load_item(0)
	
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var item_count = 5
		for i in item_count:
			var new_item:Dictionary = {}
			items.append(new_item)
			_check_item(i)
		_save_json()
		
func _save_json() -> void:
	var save_data:Dictionary = {
		"items" : items
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	ItemsUpdated.emit(items)

func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	items = save_data["items"]
	item_count_spinbox.value = items.size()
	
	for index in range(items.size()):
		_check_item(index)
	
	ItemsUpdated.emit()
	
func _check_item(index:int):
	if items[index] == null:
		items[index] = {}
	var item:Dictionary = items[index]
	
	if item.has("name"):
		return
	item.name = "Item " + str(index)
	item.desc = ""
	item.icon = ""
	item.type = 0
	item.price = 0
	item.consumable = 0
	
	item.scope_side = 0
	item.scope_number = 0
	item.scope_random = 1
	item.occasion = 0
	item.animation = 0
	
	item.speed = 0
	item.success_rate = 100
	item.repeat = 1
	item.tp_gain = 0
	
	item.damage_type = 0
	item.element = 0
	item.formula = ""
	item.note = ""
	
	items[index] = item

func _item_buttons():
	for i in items_box.get_children():
		items_box.remove_child(i)
		i.queue_free()
	
	var index:int = 0
	for i:Dictionary in items:
		var hbox:HBoxContainer = HBoxContainer.new()
		var index_label:Label = Label.new()
		var new_button:Button = Button.new()
		
		
		hbox.add_child(index_label)
		hbox.add_child(new_button)
		
		items_box.add_child(hbox)
		
		index_label.text = str(index)
		index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		index_label.custom_minimum_size.x = 13
		
		new_button.custom_minimum_size.x = 176.0
		_check_item(index)
		new_button.text = i.name
		new_button.button_down.connect(_load_item.bind(index))
		index += 1

func _load_item(index:int):
	cur_item_index = index
	var item:Dictionary = items[index]
	
	name_edit.text = item.name
	desc_edit.text = item.desc
	if item.icon != "":
		texture.texture =  load(item.icon)
	item_type_button.select(item.type)
	price_box.value = item.price
	consumable_button.select(item.consumable)
	
	scope_option_button.select(item.scope_side)
	number_option_button.select(item.scope_number)
	random_spin_box.value = item.scope_random
	occaision_option_button.select(item.occasion)
	animation_option_button.select(item.animation)
	
	speed_spin_box.value = item.speed
	success_spin_box.value = item.success_rate
	repeat_spin_box.value = item.repeat
	tp_gain_spin_box.value = item.tp_gain
	
	damage_type_option_button.select(item.damage_type)
	element_type_option_button.select(item.element)
	formula_editor.text = item.formula
	notes_edit.text = item.note

func _on_change_item_max_button_button_down() -> void:
	items.resize(item_count_spinbox.value)
	for index in range(items.size()):
		_check_item(index)
	_item_buttons()

func _on_name_edit_text_changed(new_text: String) -> void:
	items[cur_item_index].name = new_text
	items_box.get_child(cur_item_index).get_child(1).text = new_text


func _on_desc_edit_text_changed() -> void:
	items[cur_item_index].desc = desc_edit.text

func _on_texture_button_button_down() -> void:
	pass #not implementing yet

func _on_item_type_button_item_selected(index: int) -> void:
	items[cur_item_index].type = index

func _on_price_box_value_changed(value: float) -> void:
	items[cur_item_index].price = value

func _on_consumable_button_item_selected(index: int) -> void:
	items[cur_item_index].consumable = index

func _on_scope_option_button_item_selected(index: int) -> void:
	items[cur_item_index].scope_side = index


func _on_number_option_item_selected(index: int) -> void:
	items[cur_item_index].scope_number = index

func _on_random_spin_box_value_changed(value: float) -> void:
	items[cur_item_index].scope_random = value


func _on_occaison_option_button_item_selected(index: int) -> void:
	items[cur_item_index].occasion = index

func _on_animation_option_button_item_selected(index: int) -> void:
	items[cur_item_index].animation = index


func _on_speed_spin_box_value_changed(value: float) -> void:
	items[cur_item_index].speed = value


func _on_success_rate_spin_box_value_changed(value: float) -> void:
	items[cur_item_index].success_rate = value


func _on_repeat_spin_box_value_changed(value: float) -> void:
	items[cur_item_index].repeat = value


func _on_tp_gain_spin_box_value_changed(value: float) -> void:
	items[cur_item_index].tp_gain = value


func _on_damage_type_option_button_item_selected(index: int) -> void:
	items[cur_item_index].damage_type = index


func _on_element_type_option_button_item_selected(index: int) -> void:
	items[cur_item_index].element = index


func _on_formula_editor_text_changed() -> void:
	items[cur_item_index].formula = formula_editor.text


func _on_notes_text_edit_text_changed() -> void:
	items[cur_item_index].note = notes_edit.text
