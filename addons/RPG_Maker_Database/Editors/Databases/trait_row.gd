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
@onready var status_option_button: OptionButton = $StatusOptionButton
@onready var skill_types_option_button: OptionButton = $SkillTypesOptionButton
@onready var skill_option_button: OptionButton = $SkillOptionButton
@onready var weapon_option_button: OptionButton = $WeaponOptionButton
@onready var armor_option_button: OptionButton = $ArmorOptionButton
@onready var lock_equip_option_button: OptionButton = $LockEquipOptionButton
@onready var slot_type_option_button: OptionButton = $SlotTypeOptionButton
@onready var special_flag_option_button: OptionButton = $SpecialFlagOptionButton
@onready var collaspe_effect_option_button: OptionButton = $CollaspeEffectOptionButton
@onready var party_ability: OptionButton = $PartyAbility
@onready var percent_multiplier_spin_box: SpinBox = $PercentMultiplierSpinBox
@onready var additive_spin_box: SpinBox = $AdditiveSpinBox
#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all()
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
	
	function_option.show()
	function_option.select(index)
	
	argument = arg_index
	argument_value = 100
	percent_multiplier_spin_box.value = 100
	on_value_changed(arg_value)
	
	match index:
		0: #element rate
			state = STATE.ELEMENT_RATE
			element_option_button.show()
			percent_multiplier_spin_box.show()
			var elements = TypesEditor.type_data[0] #elements list
			element_option_button.get_popup().clear()
			for e in elements:
				element_option_button.get_popup().add_item(e)
			element_option_button.select(arg_index)
			
			percent_multiplier_spin_box.value = arg_value

		1: 
			state = STATE.DEBUFF_RATE
			stat_option_button.show()
			percent_multiplier_spin_box.show()
			
			stat_option_button.select(arg_index)
			percent_multiplier_spin_box.value = arg_value
		2: 
			state = STATE.STATE_RATE
		3: #State Resist
			pass
		4: #Parameter
			pass
		5: #Ex. Parameter
			pass
		6: #SP Parameter
			pass
		
		
		
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
