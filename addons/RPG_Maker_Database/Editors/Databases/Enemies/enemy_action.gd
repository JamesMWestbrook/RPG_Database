extends VBoxContainer
class_name EnemyAction

@export var skill_option:OptionButton
@export var rating_spin_box:SpinBox

@onready var option_button: OptionButton = $Options/OptionButton
@onready var turn_spin_box: SpinBox = $Options/TurnSpinBox
@onready var plus_label: Label = $Options/PlusLabel
@onready var to_turn_spin_box: SpinBox = $Options/ToTurnSpinBox
@onready var stat_spin_box: SpinBox = $Options/StatSpinBox
@onready var stat_to_label: Label = $Options/StatToLabel
@onready var stat_spin_box_2: SpinBox = $Options/StatSpinBox2
@onready var state_option: OptionButton = $Options/StateOption
@onready var level_spin_box: SpinBox = $Options/LevelSpinBox
@onready var switch_option_button: OptionButton = $Options/SwitchOptionButton

signal action_updated()

var chosen_skill:int
var rating:int
var option_chosen:int
var arg_1:int
var arg_2:int


func _ready() -> void:
	_hide_all()
	await get_tree().process_frame
	_load_skills()
	_load_states()

func _hide_all():
	for i in $Options.get_children():
		i.hide()
	option_button.show()

func _load(action:Dictionary):
	_on_option_button_item_selected(action.option_chosen, true)
	await get_tree().process_frame
	chosen_skill = action.chosen_skill
	rating = action.rating
	option_chosen = action.option_chosen
	arg_1 = action.arg_1
	arg_2 = action.arg_2
	
	skill_option.select(action.chosen_skill)
	option_button.select(action.option_chosen)
	rating_spin_box.value = action.rating
	match action.option_chosen:
		0: #always
			pass
		1: #turn
			turn_spin_box.value = action.arg_1
			to_turn_spin_box.value = action.arg_2
		2: #hp
			stat_spin_box.value = action.arg_1
			stat_spin_box_2.value = action.arg_2
		3:#mp
			stat_spin_box.value = action.arg_1
			stat_spin_box_2.value = action.arg_1
		4: #state
			state_option.select(action.arg_1)
		5: #party level
			level_spin_box.value = action.arg_1
		6: #switch
			switch_option_button.select(action.arg_1)

func _load_skills():
	skill_option.clear()
	for skill in SkillEditor.skills:
		skill_option.add_item("Skill: " + skill.name)
func _load_states():
	pass
func _on_option_button_item_selected(index: int, loading:bool = false) -> void:
	_hide_all()
	option_chosen = index
	arg_1 = 0
	arg_2 = 0
	match index:
		0: #always
			pass
		1: #turn
			turn_spin_box.show()
			turn_spin_box.value = 0
			plus_label.show()
			to_turn_spin_box.show()
			to_turn_spin_box.value = 0
		2: #hp
			stat_spin_box.show()
			stat_spin_box.value = 0
			stat_to_label.show()
			stat_spin_box_2.show()
			stat_spin_box_2.value = 0
		3:#mp
			stat_spin_box.show()
			stat_spin_box.value = 0
			stat_to_label.show()
			stat_spin_box_2.show()
			stat_spin_box_2.value = 0
		4: #state
			state_option.show()
			state_option.select(0)
		5: #party level
			level_spin_box.show()
			level_spin_box.value = 1
		6: #switch
			switch_option_button.show()
			switch_option_button.select(0)
	if !loading:
		action_updated.emit()


func _on_skill_option_button_item_selected(index: int) -> void:
	chosen_skill = index
	action_updated.emit()

func _on_rating_spin_box_value_changed(value: float) -> void:
	rating = value
	action_updated.emit()


func _on_turn_spin_box_value_changed(value: float) -> void:
	arg_1 = value
	action_updated.emit()


func _on_to_turn_spin_box_value_changed(value: float) -> void:
	arg_2 = value
	action_updated.emit()


func _on_stat_spin_box_value_changed(value: float) -> void:
	arg_1 = value
	action_updated.emit()


func _on_stat_spin_box_2_value_changed(value: float) -> void:
	arg_2 = value
	action_updated.emit()
	


func _on_state_option_item_selected(index: int) -> void:
	arg_1 = index
	action_updated.emit()


func _on_level_spin_box_value_changed(value: float) -> void:
	arg_1 = value
	action_updated.emit()


func _on_switch_option_button_item_selected(index: int) -> void:
	arg_1 = index
	action_updated.emit()
	
