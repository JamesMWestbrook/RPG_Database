extends Control
class_name EnemyEditor
#region
@export var enemy_count_spinbox:SpinBox
@export var enemy_item_list:ItemList

@export var name_edit:LineEdit
@export var texture:TextureRect
@export var default_image = load("res://addons/RPG_Maker_Database/Editors/DefaultImage.png")
@export var enemy_scene_path:Label

@export var atk_spin_box:SpinBox
@export var def_spin_box:SpinBox
@export var mat_spin_box:SpinBox
@export var mdef_spin_box:SpinBox
@export var agi_spin_box:SpinBox
@export var lck_spin_box:SpinBox
@export var mhp_spin_box:SpinBox
@export var mmp_spin_box:SpinBox

@export var exp_spin_box:SpinBox
@export var gold_spin_box:SpinBox
@export var jp_spin_box:SpinBox

@export var note_edit:TextEdit
@export var desc_edit:TextEdit

@onready var action_container: VBoxContainer = $"ScrollContainer/BoxContainer/3rd Column/ScrollContainer/ActionContainer"

#endregion

const JSON_SAVE_PATH:String = "res://data/enemies.json"
static var enemies:Array
var cur_enemy_index:int

signal EnemiesUpdated(enemies)
func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_enemy_buttons()
	_load_enemy(0)
	
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var enemy_count = 5
		for i in enemy_count:
			var new_enemy:Dictionary = {}
			enemies.append(new_enemy)
			_check_enemy(i)
		_save_json()
		
func _save_json() -> void:
	var save_data:Dictionary = {
		"enemies" : enemies
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	EnemiesUpdated.emit(enemies)

func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	enemies = save_data["enemies"]
	enemy_count_spinbox.value = enemies.size()
	
	for index in range(enemies.size()):
		_check_enemy(index)
	
	EnemiesUpdated.emit()
	
func _on_change_enemy_max_button_button_down() -> void:
	enemies.resize(enemy_count_spinbox.value)
	for index in range(enemies.size()):
		_check_enemy(index)
	_enemy_buttons()

func _check_enemy(index:int):
	if enemies[index] == null:
		enemies[index] = {}
	var enemy:Dictionary = enemies[index]
	
	if enemy.has("name"):
		return
	enemy.name = "enemy " + str(index)
	enemy.texture = ""
	enemy.desc = ""
	
	enemy.atk = 1
	enemy.def = 1
	enemy.mat = 1
	enemy.mdef = 1
	enemy.agi = 1
	enemy.lck = 1
	enemy.mhp = 1
	enemy.mmp = 1
	
	enemy.exp = 0
	enemy.gold = 0
	enemy.jp = 0
	
	enemy.note = ""
	enemy.desc = ""
	
	enemy.actions = []
	
	enemies[index] = enemy

func _enemy_buttons():
	enemy_item_list.clear()
	
	var index:int = 0
	for w:Dictionary in enemies:
		
		var new_name = str(index) + " " + w.name
		enemy_item_list.add_item(new_name)
		index += 1

func _load_enemy(index:int):
	cur_enemy_index = index
	var enemy:Dictionary = enemies[cur_enemy_index]
	
	name_edit.text = enemy.name
	desc_edit.text = enemy.desc
	if enemy.texture != "":
		texture.texture = load(enemy.texture)
	else:
		texture.texture = default_image
	
	atk_spin_box.value = enemy.atk
	def_spin_box.value = enemy.def
	mat_spin_box.value = enemy.mat
	mdef_spin_box.value = enemy.mdef
	agi_spin_box.value = enemy.agi
	lck_spin_box.value = enemy.lck
	mhp_spin_box.value = enemy.mhp
	mmp_spin_box.value = enemy.mmp
	
	exp_spin_box.value = enemy.exp
	gold_spin_box.value = enemy.gold
	jp_spin_box.value = enemy.jp
	
	note_edit.text = enemy.note
	desc_edit.text = enemy.desc

	action_container._load(enemy.actions)

func _on_name_edit_text_changed(new_text: String) -> void:
	enemies[cur_enemy_index].name = new_text
	#enemy_item_list.set_item_text(cur_enemy_index, new_text)
	enemy_item_list.set_item_text(cur_enemy_index, str(cur_enemy_index) + " " + new_text)


func _on_desc_edit_text_changed() -> void:
	enemies[cur_enemy_index].desc = desc_edit.text
	
func _on_texture_file_dialog_file_selected(path: String) -> void:
	if path.get_extension() == "png":
		texture.texture = load(path)
	if path.get_extension() == "tscn":
		texture.texture = null
		enemy_scene_path.text = path.get_file()
	enemies[cur_enemy_index].texture = path


func _on_attack_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].atk = value


func _on_defense_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].def = value


func _on_m_attack_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].mat = value


func _on_m_defense_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].mdef = value


func _on_agi_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].agi = value


func _on_lck_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].lck = value


func _on_mhp_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].mhp = value


func _on_mmp_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].mmp = value


func _on_exp_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].exp = value


func _on_gold_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].goldindex = value


func _on_jp_spin_box_value_changed(value: float) -> void:
	enemies[cur_enemy_index].jp = value


func _on_note_text_edit_text_changed() -> void:
	enemies[cur_enemy_index].note = note_edit.text


func _on_desc_text_edit_text_changed() -> void:
	enemies[cur_enemy_index].desc = desc_edit.text


func _on_action_container_updated_actions(_actions: Variant) -> void:
	enemies[cur_enemy_index].actions = _actions
