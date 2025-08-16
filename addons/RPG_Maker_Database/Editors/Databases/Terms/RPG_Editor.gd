extends Control
class_name RPG_Editor

@export var DataType:String
var JSON_SAVE_PATH:String
@export var Nodes:Array[Node]
var data:Array


func _ready() -> void:
	if DataType == "":
		printerr("You need to set a data type in the editor for node " + name + "!")
	JSON_SAVE_PATH = "res://data/" + DataType + ".json"

func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		_save_json()
func _save_json():
	var data:Dictionary
	for i in Nodes:
		if i is LineEdit:
			data[i.name] = i.text
	
	
	var save_data:Dictionary = {
		DataType : data
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	
	
func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	var data = save_data[DataType]
