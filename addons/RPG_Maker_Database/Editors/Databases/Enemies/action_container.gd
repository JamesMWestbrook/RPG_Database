extends VBoxContainer

const ENEMY_ACTION = preload("res://addons/RPG_Maker_Database/Editors/Databases/Enemies/enemy_action.tscn")
@onready var action_list: VBoxContainer = $ActionList

var actions:Array

signal UpdatedActions(actions)

func _on_add_action_button_button_down() -> EnemyAction:
	var new_action = ENEMY_ACTION.instantiate()
	new_action.action_updated.connect(_update_list)
	action_list.add_child(new_action)
	return new_action
	
func _update_list():
	actions.clear()
	for action:EnemyAction in action_list.get_children():
		var new_action:Dictionary
		new_action.chosen_skill = action.chosen_skill
		new_action.rating = action.rating
		new_action.option_chosen = action.option_chosen
		new_action.arg_1 = action.arg_1
		new_action.arg_2 = action.arg_2
		actions.append(new_action)
	UpdatedActions.emit(actions)
