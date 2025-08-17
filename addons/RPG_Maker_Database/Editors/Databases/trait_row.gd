@tool
extends HBoxContainer
class_name Trait


enum STATE{
	ELEMENT_RATE,
	DEBUFF_RATE,
	STATE_RATE
}
var state: STATE = STATE.ELEMENT_RATE
var argument:int: #Example, physical/fire, state knockout
	set(value):
		argument = value
		changed.emit()
var argument_value:int = 100: # Modifier for argument, example 105%
	set(value):
		argument_value = value
		changed.emit()
		
var do_not_count_me:bool
signal changed()

#region Onreadys
@onready var function_option: OptionButton = $FunctionOption
@onready var element_option_button: OptionButton = $ElementOptionButton
@onready var stat_option_button: OptionButton = $StatOptionButton
@onready var ex_option_button: OptionButton = $ExOptionButton
@onready var sp_option_button: OptionButton = $SpOptionButton
@onready var status_option_button: OptionButton = $StatusOptionButton
@onready var skill_types_option_button: OptionButton = $SkillTypesOptionButton
@onready var skill_option_button: OptionButton = $SkillOptionButton
@onready var weapon_option_button: OptionButton = $WeaponOptionButton
@onready var armor_option_button: OptionButton = $ArmorOptionButton
@onready var lock_equip_option_button: OptionButton = $LockEquipOptionButton
@onready var slot_type_option_button: OptionButton = $SlotTypeOptionButton
@onready var special_flag_option_button: OptionButton = $SpecialFlagOptionButton
@onready var collapse_effect_option_button: OptionButton = $CollapseEffectOptionButton
@onready var party_ability: OptionButton = $PartyAbility
@onready var percent_multiplier_spin_box: SpinBox = $PercentMultiplierSpinBox
@onready var additive_spin_box: SpinBox = $AdditiveSpinBox
#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all()
	$DeleteButton.show()
	set_normal()
	#_on_function_option_item_selected(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func hide_all():
	for i in get_children():
		i.hide()
func set_normal():
	function_option.show()
	element_option_button.show()
	percent_multiplier_spin_box.show()
	
func _on_function_option_item_selected(index: int, arg_index:int = 0, arg_value:int = 100) -> void:
	hide_all()
	$DeleteButton.show()
	state = index
	function_option.show()
	function_option.select(index)
	
	argument = arg_index
	argument_value = 100
	percent_multiplier_spin_box.value = 100
	percent_multiplier_spin_box.prefix = "*"
	on_value_changed(arg_value)
	
	match index:
		0: #element rate
			element_option_button.show()
			percent_multiplier_spin_box.show()
			_on_element_option_button_button_down()
			element_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value

		1: #debuff rate
			stat_option_button.show()
			percent_multiplier_spin_box.show()
			
			stat_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value
		2: 
			status_option_button.show()
			percent_multiplier_spin_box.show()
			_on_status_option_button_button_down()
			status_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value
		3: #State Resist
			status_option_button.show()
			_on_status_option_button_button_down()
			status_option_button.select(arg_index)
		4: #Parameter
			stat_option_button.show()
			percent_multiplier_spin_box.show()
			
			stat_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value
		5: #Ex. Parameter
			ex_option_button.show()
			percent_multiplier_spin_box.show()
			percent_multiplier_spin_box.prefix = "+"
			
			ex_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value
		6: #SP Parameter
			sp_option_button.show()
			percent_multiplier_spin_box.show()
			
			sp_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value
		7: #Attack Element
			element_option_button.show()
			_on_element_option_button_button_down()
			element_option_button.select(arg_index)
		8: #attack state
			status_option_button.show()
			percent_multiplier_spin_box.show()
			percent_multiplier_spin_box.prefix = "+"
			_on_status_option_button_button_down()
			status_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value
		9: #attack speed
			additive_spin_box.show()
			additive_spin_box.value = arg_value
		10:#attack times +
			additive_spin_box.show()
			additive_spin_box.value = arg_value
		11: #Attack Skill
			skill_option_button.show()
			_on_skill_option_button_button_down()
			skill_option_button.select(arg_index)
		12: #Add Skill Type
			skill_types_option_button.show()
			_on_skill_types_option_button_button_down()
			skill_types_option_button.select(arg_index)
		13: #Seal Skill Type
			skill_types_option_button.show()
			_on_skill_types_option_button_button_down()
			skill_types_option_button.select(arg_index)
		14: #Add Skill
			skill_option_button.show()
			_on_skill_option_button_button_down()
			skill_option_button.select(arg_index)
		15: #Seal Skill
			skill_option_button.show()
			_on_skill_option_button_button_down()
			skill_option_button.select(arg_index)
		16: #Equip Weapon
			weapon_option_button.show()
			_on_weapon_option_button_button_down()
			weapon_option_button.select(arg_index)
		17: #Equip Armors
			armor_option_button.show()
			_on_armor_option_button_button_down()
			armor_option_button.select(arg_index)
		18: #Lock Equip Slot
			lock_equip_option_button.show()
			_set_equip()
			lock_equip_option_button.select(arg_index)
		19: #seal equip
			lock_equip_option_button.show()
			_set_equip()
			lock_equip_option_button.select(arg_index)
		20: #Slot type, normal or duel wield
			slot_type_option_button.show()
			slot_type_option_button.select(arg_index)
		21: #action time+
			percent_multiplier_spin_box.show()
			percent_multiplier_spin_box.prefix = "+"
			percent_multiplier_spin_box.value = arg_value
		22: #special flag
			special_flag_option_button.show()
			special_flag_option_button.select(arg_index)
		23: #collapse effect
			collapse_effect_option_button.show()
			collapse_effect_option_button.select(arg_index)
		24: #party ability
			party_ability.show()
			party_ability.select(arg_index)
		25: #Follower Only, doesn't participate in battle
			#also called Bystander
			pass
	changed.emit()
		
func _on_argument_option_selected(index:int) -> void:
	argument = index
	
func on_value_changed(value: float) -> void:
	argument_value = value


func _on_stat_option_button_item_selected(index: int) -> void:
	argument = index
	


func _on_delete_button_button_down() -> void:
	do_not_count_me = true
	changed.emit()
	queue_free()


func _on_element_option_button_button_down() -> void:
	var elements = TypesEditor.type_data[0] #elements list
	element_option_button.clear()
	for e in elements:
		element_option_button.add_item(e)


func _on_status_option_button_button_down() -> void:
	var states = States.states
	status_option_button.clear()
	for s in states:
		status_option_button.add_item(s.name)


func _on_status_option_button_item_selected(index: int) -> void:
	argument = index


func _on_ex_option_button_item_selected(index: int) -> void:
	argument = index


func _on_sp_option_button_item_selected(index: int) -> void:
	argument = index


func _on_skill_option_button_button_down() -> void:
	var skills = SkillEditor.skills
	skill_option_button.clear()
	for s in skills:
		skill_option_button.add_item(s.name)


func _on_skill_option_button_item_selected(index: int) -> void:
	argument = index


func _on_skill_types_option_button_button_down() -> void:
	skill_types_option_button.clear()
	var skill_types:Array = TypesEditor.type_data[1]
	for s in skill_types:
		skill_types_option_button.add_item(s)


func _on_skill_types_option_button_item_selected(index: int) -> void:
	argument = index


func _on_weapon_option_button_button_down() -> void:
	weapon_option_button.clear()
	var weapons:Array = TypesEditor.type_data[2]
	for w in weapons:
		weapon_option_button.add_item(w)

func _on_weapon_option_button_item_selected(index: int) -> void:
	argument = index


func _on_armor_option_button_button_down() -> void:
	armor_option_button.clear()
	var armors:Array = TypesEditor.type_data[3]
	for a in armors:
		armor_option_button.add_item(a)


func _on_armor_option_button_item_selected(index: int) -> void:
	argument = index
func _set_equip():
	lock_equip_option_button.clear()
	var equips = TypesEditor.type_data[4]
	for e in equips:
		lock_equip_option_button.add_item(e)


func _on_lock_equip_option_button_item_selected(index: int) -> void:
	argument = index


func _on_slot_type_option_button_item_selected(index: int) -> void:
	argument = index


func _set_argument(index:int):
	argument = index
