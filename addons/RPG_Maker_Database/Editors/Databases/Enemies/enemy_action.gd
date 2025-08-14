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

func _hide_all():
	for i in $Options.get_children():
		i.hide()
	option_button.show()

func _load_skills():
	skill_option.clear()
	for skill in SkillEditor.skills:
		skill_option.add_item(skill.name)
	
func _on_option_button_item_selected(index: int) -> void:
	_hide_all()
	option_chosen = index
	match index:
		0: #always
			pass
		1: #turn
			turn_spin_box.show()
			plus_label.show()
			to_turn_spin_box.show()
		2: #hp
			stat_spin_box.show()
			stat_to_label.show()
			stat_spin_box_2.show()
		3:#mp
			stat_spin_box.show()
			stat_to_label.show()
			stat_spin_box_2.show()
		4: #state
			state_option.show()
		5: #party level
			level_spin_box.show()
		6: #switch
			switch_option_button.show()
	action_updated.emit()


func _on_skill_option_button_item_selected(index: int) -> void:
	chosen_skill = index

func _on_rating_spin_box_value_changed(value: float) -> void:
	rating = value
