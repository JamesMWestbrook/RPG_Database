extends Control
class_name Troops

const ENEMY_SLOT = preload("res://addons/RPG_Maker_Database/Editors/Databases/Troops/enemy_slot.tscn")

@export var troop_count_spinbox:SpinBox

var cur_troop_index:int
var troops:Array
const JSON_SAVE_PATH = "res://data/troops.json"

signal TroopsUpdated(troops)

func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_load_buttons()
	
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var troop_count = 5
		for i in troop_count:
			var new_troop:Dictionary = {}
			troops.append(new_troop)
			_check_troop(i)
		_save_json()
func _save_json():
	var save_data:Dictionary = {
		"troops" : troops
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	TroopsUpdated.emit(troops)
	
	
func _load_json(file:FileAccess):
	pass
func _check_troop(index:int):
	if troops[index] == null:
		troops[index] = {}
	var troop:Dictionary = troops[index]
	if troop.has("enemies"):
		return
	troop.enemies = []
	

func _load_buttons():
	pass
