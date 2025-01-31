@tool
extends Control

const SAVE_PATH = "res://data/types.json"

@export var types:Array[TypeColumn]

var type_data:Array



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type_data.resize(5)
	_load_json()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _load_json():
	if !FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH,FileAccess.READ)
	var json_string =  file.get_file_as_string(SAVE_PATH)
	type_data = JSON.parse_string(json_string)
	for i in 5:
		types[i].sub_types = type_data[i]
		types[i].max_edit.value = type_data[i].size()
		types[i]._on_set_max_button_down()


func _save_json():
	var json_data = JSON.stringify(type_data)
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	file.store_string(json_data)
	


func _on_elements_data_changed(types: Array, index) -> void:
	type_data[index] = types
