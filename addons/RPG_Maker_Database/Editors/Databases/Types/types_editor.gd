@tool
extends Control
class_name TypesEditor
const SAVE_PATH = "res://data/types.json"

@export var types:Array[TypeColumn]

static var type_data:Array
var slot_quantities:Array

signal load_quantities(quantities)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type_data.resize(5)
	_load_json()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _load_json():
	if !FileAccess.file_exists(SAVE_PATH):
		for i:int in range(type_data.size()):
			if type_data[i] == null:
				type_data[i] = []
		_save_json()
		return
	var file = FileAccess.open(SAVE_PATH,FileAccess.READ)
	var json_string =  file.get_file_as_string(SAVE_PATH)
	var json_data = JSON.parse_string(json_string)
	type_data = json_data.type_data
	slot_quantities = json_data.slot_quantities
	load_quantities.emit(slot_quantities)
	for i in 5:
		var data = type_data[i]
		if data != null:
			types[i].sub_types = type_data[i]
			types[i].max_edit.value = type_data[i].size()
			types[i]._on_set_max_button_down()


func _save_json():
	var new_save = {
		"type_data": type_data,
		"slot_quantities": slot_quantities
	}
	
	var json_data = JSON.stringify(new_save)
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	file.store_string(json_data)
	


func _on_elements_data_changed(types: Array, index) -> void:
	type_data[index] = types


func _on_equip_types_quantity_changed(quantities: Array) -> void:
	slot_quantities = quantities
