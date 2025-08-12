extends Control
class_name Items

#region
@onready var items_box: VBoxContainer = $"ScrollContainer/BoxContainer/1st Column/ScrollContainer/ItemsBox"
@export var name_edit:LineEdit
@export var desc_edit:TextEdit
#endregion

var cur_item_index:int
static var items:Array
const JSON_SAVE_PATH = "res://data/items.json"

signal ItemsUpdated(items)
func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_item_buttons()
	
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
		_item_buttons()
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
	pass
	
func _check_item(index:int):
	if items[index] == null:
		items[index] = {}
	var item:Dictionary = items[index]
	
	if item.has("name"):
		return
	item.name = "Item " + str(index)
	
	
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
	var item:Dictionary = items[index]
	name_edit.text = item.name
	
