@tool
extends HBoxContainer

signal changed

@onready var skill_option_button: OptionButton = $SkillOptionButton
@onready var level_spin_box: SpinBox = $LevelSpinBox

var selected_index:int
var skill_index:int:
	set(value):
		skill_index = value
		changed.emit()
var level_learned:int = 1:
	set(value):
		level_learned = value
		changed.emit()
var do_not_count_me:bool = false

func _on_skill_option_button_button_down() -> void:
	var skills:Array = SkillEditor.skills
	skill_option_button.clear()
	for s in skills:
		skill_option_button.add_item(s.name)
	if selected_index < skill_option_button.item_count:
		skill_option_button.select(selected_index)
func _load_skill(index:int = -1):
	if index != -1:
		skill_option_button.select(index)

func _on_skill_option_button_item_selected(index: int) -> void:
	selected_index = index
	skill_index = index
	


func _on_level_spin_box_value_changed(value: float) -> void:
	level_learned = int(value)


func _on_delete_button_down() -> void:
	do_not_count_me = true
	changed.emit()
	queue_free()
