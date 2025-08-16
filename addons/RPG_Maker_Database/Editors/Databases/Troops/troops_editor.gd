extends Control
class_name Troops

const ENEMY_SLOT = preload("res://addons/RPG_Maker_Database/Editors/Databases/Troops/enemy_slot.tscn")
const TROOP_SAMPLE_ENEMY = preload("res://addons/RPG_Maker_Database/Editors/Databases/Troops/Troop_Layout/troop_sample_enemy.tscn")

#region
@export var troop_count_spinbox:SpinBox
@export var troop_item_list:ItemList
@export var enemy_item_list:ItemList

@export var slots_container:HBoxContainer
@export var battlefield:Node2D
#endregion

var cur_troop_index:int
var troops:Array
const JSON_SAVE_PATH = "res://data/troops.json"

var cur_selected_enemy:int = -1

signal TroopsUpdated(troops)

func _ready() -> void:
	await get_tree().process_frame
	_check_json()
	_load_troop_buttons()
	_load_enemies()
	_load_slots()
	_load_troop(0)
	
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
		#_save_json()
func _save_json():
	var save_data:Dictionary = {
		"troops" : troops
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	TroopsUpdated.emit(troops)
	
	
func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	troops = save_data["troops"]
	troop_count_spinbox.value = troops.size()
	
	for index in range(troops.size()):
		_check_troop(index)
	
	TroopsUpdated.emit()

func _check_troop(index:int):
	if troops[index] == null:
		troops[index] = {}
	var troop:Dictionary = troops[index]
	if troop.has("enemies"):
		return
	troop.name = "Troop " + str(index)
	var enemies:Array
	for i in TroopSetup.slots.size():
		enemies.append(-1)
	troop.enemies = enemies
	pass
	
func _load_troop_buttons():
	troop_item_list.clear()
	for troop:Dictionary in troops:
		troop_item_list.add_item(troop.name)

func _load_enemies():
	enemy_item_list.clear()
	for enemy in EnemyEditor.enemies:
		enemy_item_list.add_item(enemy.name)
func _load_slots():
	_clear_children(slots_container)
	for i in TroopSetup.slots.size():
		var new_slot:EnemySlot = ENEMY_SLOT.instantiate()
		slots_container.add_child(new_slot)
		new_slot.assign_button.button_down.connect(_assign_enemy.bind(i))
		new_slot.clear_button.button_down.connect(_design_enemy.bind(i))
	
func _on_char_tab_container_tab_clicked(tab: int) -> void:
	if tab != 3:
		return
	_load_enemies()
	_load_slots()
	_load_troop(0)
	

func _on_enemy_item_list_item_selected(index: int) -> void:
	cur_selected_enemy = index

func _clear_children(node):
	for i in node.get_children():
		node.remove_child(i)
		i.queue_free()

func _load_troop(index:int):
	_clear_children(battlefield)
	cur_troop_index = index
	var enemies:Array = troops[cur_troop_index].enemies
	var slot_index:int = 0
	for i in enemies:
		if i == -1:
			slot_index += 1
			continue
		var chosen_graphic_path:String = EnemyEditor.enemies[i].texture
		var new_enemy = TROOP_SAMPLE_ENEMY.instantiate()
		new_enemy.texture = load(chosen_graphic_path)
		battlefield.add_child(new_enemy)
		new_enemy.position = Vector2(TroopSetup.slots[slot_index].x,TroopSetup.slots[slot_index].y)
		slot_index += 1
		
	
func _assign_enemy(slot_index:int):
	#grab graphic
	var chosen_graphic_path:String = EnemyEditor.enemies[cur_selected_enemy].texture
	var new_enemy = TROOP_SAMPLE_ENEMY.instantiate()
	new_enemy.texture = load(chosen_graphic_path)
	battlefield.add_child(new_enemy)
	new_enemy.position = Vector2(TroopSetup.slots[slot_index].x,TroopSetup.slots[slot_index].y)
	troops[cur_troop_index].enemies[slot_index] = cur_selected_enemy
	pass

func _design_enemy(slot_index:int):#removing an enemy from a slot 
	troops[cur_troop_index].enemies[slot_index] = -1
	_load_troop(cur_troop_index)


func _on_name_line_edit_text_changed(new_text: String) -> void:
	troops[cur_troop_index].name = new_text
	troop_item_list.set_item_text(cur_troop_index, str(cur_troop_index) + " " + new_text)
