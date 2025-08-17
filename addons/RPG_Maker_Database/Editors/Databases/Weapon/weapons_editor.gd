@tool
extends Control
class_name Weapons

@export var placeholder_icon:Texture2D

#region
@export var weapon_count_spinbox:SpinBox
@export var weapon_item_list:ItemList
@export var texture:TextureRect
@export var name_edit: LineEdit
@export var desc_edit:TextEdit
@export var weapon_type_option_button:OptionButton
@export var price_spin_box:SpinBox
@export var animation_type_option_button:OptionButton

@export var atk_spin_box:SpinBox
@export var def_spin_box:SpinBox
@export var mat_spin_box:SpinBox
@export var mdef_spin_box:SpinBox
@export var agi_spin_box:SpinBox
@export var lck_spin_box:SpinBox
@export var mhp_spin_box:SpinBox
@export var mmp_spin_box:SpinBox

@export var note_edit:TextEdit
@export var trait_container:TraitContainer
#endregion

var cur_weapon_index:int
static var weapons:Array
const JSON_SAVE_PATH = "res://data/weapons.json"

signal WeaponsUpdated(weapons)

func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_weapon_buttons()
	#_load_weapon(0)
	
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var weapon_count = 5
		for i in weapon_count:
			var new_weapon:Dictionary = {}
			weapons.append(new_weapon)
			_check_weapon(i)
		_save_json()
		
func _save_json() -> void:
	var save_data:Dictionary = {
		"weapons" : weapons
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	WeaponsUpdated.emit(weapons)

func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	weapons = save_data["weapons"]
	weapon_count_spinbox.value = weapons.size()
	
	for index in range(weapons.size()):
		_check_weapon(index)
	
	WeaponsUpdated.emit()
	
func _on_change_actor_max_button_button_down() -> void:
	weapons.resize(weapon_count_spinbox.value)
	for index in range(weapons.size()):
		_check_weapon(index)
	_weapon_buttons()

func _check_weapon(index:int):
	if weapons[index] == null:
		weapons[index] = {}
	var weapon:Dictionary = weapons[index]
	
	if weapon.has("name"):
		return
	weapon.name = "Weapon " + str(index)
	weapon.icon = ""
	weapon.desc = ""
	weapon.type = 0
	weapon.price = 0
	weapon.animation = 0
	
	weapon.atk = 0
	weapon.def = 0
	weapon.mat = 0
	weapon.mdef = 0
	weapon.agi = 0
	weapon.lck = 0
	weapon.mhp = 0
	weapon.mmp = 0
	
	weapon.note = ""
	weapon.traits = []
	
	weapons[index] = weapon
	
	
func _weapon_buttons():
	weapon_item_list.clear()
	
	var index:int = 0
	for w:Dictionary in weapons:
		
		var new_name = str(index) + " " + w.name
		weapon_item_list.add_item(new_name)
		index += 1

func _load_weapon(index:int):
	
	weapon_type_option_button.clear()
	for type in TypesEditor.type_data[2]:
		weapon_type_option_button.add_item(type)
	
	
	cur_weapon_index = index
	var weapon:Dictionary = weapons[cur_weapon_index]
	
	name_edit.text = weapon.name
	desc_edit.text = weapon.desc
	if weapon.icon != "":
		texture.texture = load(weapon.icon)
	else:
		texture.texture = placeholder_icon
	weapon_type_option_button.select(weapon.type)
	price_spin_box.value = weapon.price
	
	atk_spin_box.value = weapon.atk
	def_spin_box.value = weapon.def
	mat_spin_box.value = weapon.mat
	mdef_spin_box.value = weapon.mdef
	agi_spin_box.value = weapon.agi
	lck_spin_box.value = weapon.lck
	mhp_spin_box.value = weapon.mhp
	mmp_spin_box.value = weapon.mmp
	
	note_edit.text = weapon.note
	trait_container._clear()
	trait_container._load_traits(weapon.traits)

func _on_name_edit_text_changed(new_text: String) -> void:
	weapons[cur_weapon_index].name = new_text
	weapon_item_list.set_item_text(cur_weapon_index, str(cur_weapon_index) + " " + new_text)


func _on_desc_edit_text_changed() -> void:
	weapons[cur_weapon_index].desc = desc_edit.text


func _on_weapon_type_button_item_selected(index: int) -> void:
	weapons[cur_weapon_index].type = index


func _on_price_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].price = value


func _on_animation_button_item_selected(index: int) -> void:
	weapons[cur_weapon_index].animation = index


func _on_attack_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].atk = value


func _on_defense_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].def = value


func _on_m_attack_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].mat = value


func _on_m_defense_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].mdef = value


func _on_agi_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].agi = value


func _on_lck_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].lck = value


func _on_mhp_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].mhp = value


func _on_mmp_spin_box_value_changed(value: float) -> void:
	weapons[cur_weapon_index].mmp = value


func _on_note_text_edit_text_changed() -> void:
	weapons[cur_weapon_index].note = note_edit.text


func _on_trait_container_updated_traits(list: Variant) -> void:
	weapons[cur_weapon_index].traits = list
