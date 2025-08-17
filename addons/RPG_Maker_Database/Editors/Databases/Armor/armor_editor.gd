@tool
extends Control
class_name Armors

@export var placeholder_icon:Texture2D

#region
@export var armor_count_spinbox:SpinBox
@export var armor_item_list:ItemList
@export var texture:TextureRect
@export var name_edit: LineEdit
@export var desc_edit:TextEdit
@export var armor_type_option_button:OptionButton
@export var body_part_option_button:OptionButton
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

var cur_armor_index:int
static var armors:Array
const JSON_SAVE_PATH = "res://data/armors.json"

signal ArmorsUpdated(armors)

func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_armor_buttons()
	_load_armor(0)
	
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var armor_count = 5
		for i in armor_count:
			var new_armor:Dictionary = {}
			armors.append(new_armor)
			_check_armor(i)
		_save_json()
		
func _save_json() -> void:
	var save_data:Dictionary = {
		"armors" : armors
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	ArmorsUpdated.emit(armors)

func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	armors = save_data["armors"]
	armor_count_spinbox.value = armors.size()
	
	for index in range(armors.size()):
		_check_armor(index)
	
	ArmorsUpdated.emit()
	
func _on_change_actor_max_button_button_down() -> void:
	armors.resize(armor_count_spinbox.value)
	for index in range(armors.size()):
		_check_armor(index)
	_armor_buttons()

func _check_armor(index:int):
	if armors[index] == null:
		armors[index] = {}
	var armor:Dictionary = armors[index]
	
	if armor.has("name"):
		return
	armor.name = "armor " + str(index)
	armor.icon = ""
	armor.desc = ""
	armor.type = 0
	armor.body_part = 0
	armor.price = 0
	armor.animation = 0
	
	armor.atk = 0
	armor.def = 0
	armor.mat = 0
	armor.mdef = 0
	armor.agi = 0
	armor.lck = 0
	armor.mhp = 0
	armor.mmp = 0
	
	armor.note = ""
	armor.traits = []
	
	armors[index] = armor

func _armor_buttons():
	armor_item_list.clear()
	
	var index:int = 0
	for w:Dictionary in armors:
		
		var new_name = str(index) + " " + w.name
		armor_item_list.add_item(new_name)
		index += 1

func _load_armor(index:int):
	cur_armor_index = index
	var armor:Dictionary = armors[cur_armor_index]
	
	armor_type_option_button.clear()
	for type in TypesEditor.type_data[3]:
		armor_type_option_button.add_item(type)
	body_part_option_button.clear()
	for type in TypesEditor.type_data[4]:
		body_part_option_button.add_item(type)
		
	name_edit.text = armor.name
	desc_edit.text = armor.desc
	if armor.icon != "":
		texture.texture = load(armor.icon)
	else:
		texture.texture = placeholder_icon
	armor_type_option_button.select(armor.type)
	body_part_option_button.select(armor.body_part)
	price_spin_box.value = armor.price
	
	atk_spin_box.value = armor.atk
	def_spin_box.value = armor.def
	mat_spin_box.value = armor.mat
	mdef_spin_box.value = armor.mdef
	agi_spin_box.value = armor.agi
	lck_spin_box.value = armor.lck
	mhp_spin_box.value = armor.mhp
	mmp_spin_box.value = armor.mmp
	
	note_edit.text = armor.note
	trait_container._clear()
	trait_container._load_traits(armor.traits)

func _on_name_edit_text_changed(new_text: String) -> void:
	armors[cur_armor_index].name = new_text
	armor_item_list.set_item_text(cur_armor_index, str(cur_armor_index) + " " + new_text)


func _on_desc_edit_text_changed() -> void:
	armors[cur_armor_index].desc = desc_edit.text


func _on_armor_type_button_item_selected(index: int) -> void:
	armors[cur_armor_index].type = index


func _on_price_box_value_changed(value: float) -> void:
	armors[cur_armor_index].price = value


func _on_animation_button_item_selected(index: int) -> void:
	armors[cur_armor_index].animation = index


func _on_attack_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].atk = value


func _on_defense_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].def = value


func _on_m_attack_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].mat = value


func _on_m_defense_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].mdef = value


func _on_agi_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].agi = value


func _on_lck_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].lck = value


func _on_mhp_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].mhp = value


func _on_mmp_spin_box_value_changed(value: float) -> void:
	armors[cur_armor_index].mmp = value


func _on_note_text_edit_text_changed() -> void:
	armors[cur_armor_index].note = note_edit.text


func _on_body_part_button_item_selected(index: int) -> void:
	armors[cur_armor_index].body_part = index


func _on_trait_container_updated_traits(list: Variant) -> void:
	armors[cur_armor_index].traits = list
