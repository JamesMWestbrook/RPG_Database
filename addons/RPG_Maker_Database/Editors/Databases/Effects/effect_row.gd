extends HBoxContainer
class_name Effect
@onready var main_option_button: OptionButton = $MainOptionButton
@onready var state_option_button: OptionButton = $StateOptionButton
@onready var stat_option_button: OptionButton = $StatOptionButton
@onready var special_option_button: OptionButton = $SpecialOptionButton
@onready var skill_option_button: OptionButton = $SkillOptionButton
@onready var common_event_option_button: OptionButton = $CommonEventOptionButton
@onready var percentage_spin_box: SpinBox = $PercentageSpinBox
@onready var additive_spin_box: SpinBox = $AdditiveSpinBox
@onready var delete_button: Button = $DeleteButton

var state:int
var argument:int
var argument_value1:int
var argument_value2:int
var do_not_count_me:bool

signal Changed()

func _ready() -> void:
	_set_normal()

func _set_normal():
	main_option_button.show()
	percentage_spin_box.show()
	additive_spin_box.show()
	delete_button.show()
	
func _on_main_option_button_item_selected(index: int, arg_index:int = 0, arg_value1:int = 100,arg_value2:int=100) -> void:
	hide_all()
	main_option_button.show()
	delete_button.show()
	main_option_button.select(index)
	state = index
	argument = arg_index
	argument_value1 = arg_value1
	argument_value2 = arg_value2
	
	additive_spin_box.suffix = ""
	
	match index:
		0:#recover HP
			percentage_spin_box.value = arg_value1
			additive_spin_box.value = argument_value2
		1: #recover MP
			percentage_spin_box.value = arg_value1
			additive_spin_box.value = argument_value2

func hide_all():
	for i in get_children():
		i.hide()


func set_argument(index: int) -> void:
	argument = index
