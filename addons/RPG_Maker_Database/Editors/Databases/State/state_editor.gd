extends Control
class_name States

#region #onreadys
@export var state_count_spinbox: SpinBox
@export var states_item_list: ItemList

@export var name_line_edit:LineEdit
@export var restriction_button:OptionButton
@export var priority_spin_box:SpinBox
@export var sv_motion_button:OptionButton
@export var sv_overlay_button:OptionButton
@export var battle_end_checkbox:CheckBox
@export var restriction_checkbox:CheckBox
@export var auto_removal_button:OptionButton
@export var lower_turn_spin:SpinBox
@export var max_turn_spin:SpinBox
@export var via_damage_checkbox:CheckBox
@export var damage_spin_box:SpinBox
@export var via_walking_checkbox:CheckBox
@export var walking_spin_box:SpinBox
@export var actor_inflicted_edit:LineEdit
@export var state_persist_edit:LineEdit
@export var state_removed_edit:LineEdit
@export var trait_container:TraitContainer


#endregion
const JSON_SAVE_PATH = "res://data/states.json"

static var states:Array
var cur_state_index:int

signal StatesUpdated(states)

enum RESTRICTION{
	NONE,
	ATTACK_state,
	ATTACK_ANYONE,
	ATTACK_ALLY,
	CANNOT_MOVE
}
enum SV_MOTION{
	NORMAL,
	ABNORMAL,
	SLEEP,
	DEAD
}
enum AUTO_REMOVAL_TIMING{
	NONE,
	ACTION_END,
	TURN_END
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_state_buttons()
		
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var state_count = 5
		for i in state_count:
			var new_state:Dictionary = {}
			states.append(new_state)
			_check_state(i)
		_save_json()
func _save_json() -> void:
	var save_data:Dictionary = {
		"states" : states
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	StatesUpdated.emit(states)

func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	states = save_data["states"]
	state_count_spinbox.value = states.size()
	
	for index in range(states.size()):
		_check_state(index)
	
	StatesUpdated.emit()



func _load_state(index:int):
	_check_state(index)
	cur_state_index = index
	var state = states[cur_state_index]
	
	name_line_edit.text = state.name
	#logic for loading an icon placeholder
	restriction_button.select(state.restriction) #enums are just numbers in the end
	priority_spin_box.value = state.priority
	sv_motion_button.select(state.sv_motion)
	sv_overlay_button.select(state.sv_overlay)
	battle_end_checkbox.button_pressed = state.remove_at_battle_end
	restriction_checkbox.button_pressed = state.remove_by_restriction
	auto_removal_button.select(state.auto_removal_timing)
	lower_turn_spin.value = state.duration_min
	max_turn_spin.value = state.duration_max
	
	if state.auto_removal_timing > 0:
		lower_turn_spin.editable = true
		max_turn_spin.editable = true
	else:
		lower_turn_spin.editable = false
		max_turn_spin.editable = false
	if state.remove_by_damage:
		via_damage_checkbox.button_pressed = true
		damage_spin_box.value = state.damage_required
		damage_spin_box.editable = true
	else:
		damage_spin_box.editable = false
		
	if state.remove_by_walking:
		via_walking_checkbox.button_pressed = true
		walking_spin_box.value = state.steps_required
		walking_spin_box.editable = true
	else:
		walking_spin_box.editable = false
		
		
	actor_inflicted_edit.text = state.actor_inflicted_message
	state_persist_edit.text = state.persist_message
	state_removed_edit.text = state.removed_message
	trait_container._clear()
	trait_container._load_traits(state.traits)

func _check_state(index:int):
	if states[index] == null:
		states[index] = {}
	
	var state:Dictionary = states[index]
	if !state.has("name"):
		state.name =  "State " + str(index)
		
		state.icon = ""
		state.restriction = RESTRICTION.NONE
		state.priority = 100
		state.sv_motion = SV_MOTION.NORMAL
		state.sv_overlay = 0
		state.remove_at_battle_end = false
		state.remove_by_restriction = false
		state.auto_removal_timing = AUTO_REMOVAL_TIMING.NONE
		state.duration_min = 0
		state.duration_max = 0
		state.remove_by_damage = false
		state.damage_required = 100
		state.remove_by_walking = false
		state.steps_required = 100
		state.actor_inflicted_message = ""
		state.state_inflicted_message = ""
		state.persist_message = ""
		state.removed_message = ""
		state.traits = []
		states[index] = state
		
func _on_trait_container_updated_traits(list: Variant) -> void:
	states[cur_state_index].traits = list
	

func _on_change_actor_max_button_button_down() -> void:
	states.resize(state_count_spinbox.value)
	_state_buttons()


func _state_buttons():
	states_item_list.clear()
	
	var index:int = 0
	for i:Dictionary in states:
		states_item_list.add_item(str(index) + " " + i.name)
		index += 1


func _on_name_line_edit_text_changed(new_text: String) -> void:
	states[cur_state_index].name = new_text
	states_item_list.set_item_text(cur_state_index,str(cur_state_index) + " " + new_text)

func _on_restriction_button_item_selected(index: int) -> void:
	states[cur_state_index].restriction = index


func _on_priority_spin_box_value_changed(value: float) -> void:
	states[cur_state_index].priority = value


func _on_sv_motion_button_item_selected(index: int) -> void:
	states[cur_state_index].sv_motion = index
	

func _on_sv_overlay_button_item_selected(index: int) -> void:
	states[cur_state_index].sv_overlay = index


func _on_battle_end_checkbox_toggled(toggled_on: bool) -> void:
	states[cur_state_index].remove_at_battle_end = toggled_on

func _on_restriction_checkbox_toggled(toggled_on: bool) -> void:
	states[cur_state_index].remove_by_restriction = toggled_on


func _on_auto_removal_button_item_selected(index: int) -> void:
	states[cur_state_index].auto_removal_timing = index
	if index > 0:
		lower_turn_spin.editable = true
		max_turn_spin.editable = true
	else:
		lower_turn_spin.editable = false
		max_turn_spin.editable = false

func _on_lower_turn_spin_value_changed(value: float) -> void:
	states[cur_state_index].duration_min = value


func _on_max_turn_spin_value_changed(value: float) -> void:
	states[cur_state_index].duration_max = value


func _on_via_damage_checkbox_toggled(toggled_on: bool) -> void:
	states[cur_state_index].remove_by_damage = toggled_on
	damage_spin_box.editable = toggled_on

func _on_damage_spin_box_value_changed(value: float) -> void:
	states[cur_state_index].damage_required = value


func _on_via_walking_checkbox_toggled(toggled_on: bool) -> void:
	states[cur_state_index].remove_by_walking = toggled_on 
	walking_spin_box.editable = toggled_on

func _on_walking_spin_box_value_changed(value: float) -> void:
	states[cur_state_index].steps_required = value


func _on_actor_inflicted_edit_text_changed(new_text: String) -> void:
	states[cur_state_index].actor_inflicted_message = new_text


func _on_state_inflicted_edit_text_changed(new_text: String) -> void:
	states[cur_state_index].state_inflicted_message = new_text


func _on_state_persist_edit_text_changed(new_text: String) -> void:
	states[cur_state_index].persist_message = new_text


func _on_state_removed_edit_text_changed(new_text: String) -> void:
	states[cur_state_index].removed_message = new_text
