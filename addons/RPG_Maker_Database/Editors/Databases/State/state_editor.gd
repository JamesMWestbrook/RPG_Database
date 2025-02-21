@tool
extends Control


#region #onreadys
@onready var actor_count_spinbox: SpinBox = $BoxContainer/Column1/ActorCountSpinbox
@onready var states_v_box: VBoxContainer = $BoxContainer/Column1/ScrollContainer/StatesVBox

@onready var name_line_edit: LineEdit = $BoxContainer/Column2Scroll/VBox/HBox2/NameLineEdit
@onready var restriction_button: OptionButton = $BoxContainer/Column2Scroll/VBox/HBox4/RestrictionButton
@onready var priority_spin_box: SpinBox = $BoxContainer/Column2Scroll/VBox/HBox4/PrioritySpinBox
@onready var sv_motion_button: OptionButton = $BoxContainer/Column2Scroll/VBox/HBox6/SvMotionButton
@onready var sv_overlay_button: OptionButton = $BoxContainer/Column2Scroll/VBox/HBox6/SvOverlayButton
@onready var battle_end_checkbox: CheckBox = $BoxContainer/Column2Scroll/VBox/HBox7/BattleEndCheckbox
@onready var restriction_checkbox: CheckBox = $BoxContainer/Column2Scroll/VBox/HBox7/RestrictionCheckbox
@onready var auto_removal_button: OptionButton = $BoxContainer/Column2Scroll/VBox/HBox8/AutoRemovalButton
@onready var lower_turn_spin: SpinBox = $BoxContainer/Column2Scroll/VBox/HBox9/LowerTurnSpin
@onready var max_turn_spin: SpinBox = $BoxContainer/Column2Scroll/VBox/HBox9/MaxTurnSpin
@onready var via_damage_checkbox: CheckBox = $BoxContainer/Column2Scroll/VBox/HBox10/ViaDamageCheckbox
@onready var damage_spin_box: SpinBox = $BoxContainer/Column2Scroll/VBox/HBox10/DamageSpinBox
@onready var via_walking_checkbox: CheckBox = $BoxContainer/Column2Scroll/VBox/HBox11/ViaWalkingCheckbox
@onready var walking_spin_box: SpinBox = $BoxContainer/Column2Scroll/VBox/HBox11/WalkingSpinBox
@onready var actor_inflicted_edit: LineEdit = $BoxContainer/Column2Scroll/VBox/ActorInflictedEdit
@onready var enemy_inflicted_edit: LineEdit = $BoxContainer/Column2Scroll/VBox/EnemyInflictedEdit
@onready var state_persist_edit: LineEdit = $BoxContainer/Column2Scroll/VBox/StatePersistEdit
@onready var state_removed_edit: LineEdit = $BoxContainer/Column2Scroll/VBox/StateRemovedEdit




#endregion
const SAVE_PATH = "res://data/states.json"

var states:Array[Dictionary]
var cur_state_index:int

enum RESTRICTION{
	NONE,
	ATTACK_ENEMY,
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
	if FileAccess.file_exists(SAVE_PATH):
		_load_json()
	else:
		actor_count_spinbox.value = 5
		_on_change_actor_max_button_button_down()
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _save_json():
	pass


func _load_json():
	pass


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
	battle_end_checkbox.toggle_mode = state.remove_at_battle_end
	if state.remove_at_battle_end:
		auto_removal_button.select(state.auto_removal_timing)
		lower_turn_spin.value = state.duration_min
		max_turn_spin.value = state.duration_max
	
	

func _check_state(index:int):
	var state:Dictionary = states[index]
	if !state.has("name"):
		state.name = ""
		
		state.icon = ""
		state.restriction = RESTRICTION.NONE
		state.priority = 100
		state.sv_motion = SV_MOTION.NORMAL
		state.sv_overlay = 0
		state.remove_at_battle_end = false
		state.auto_removal_timing = AUTO_REMOVAL_TIMING.NONE
		state.duration_min = 0
		state.duration_max = 0
		state.remove_by_damage = false
		state.damage_required = 100
		state.remove_by_walking = false
		state.steps_required = 100
		state.actor_inflicted_message = ""
		state.enemy_inflicted_message = ""
		state.persist_message = ""
		state.removed_message = ""
		state.traits = []
		
func _on_trait_container_updated_traits(list: Variant) -> void:
	pass
	#states[cur_state_index].traits = list
	

func _on_change_actor_max_button_button_down() -> void:
	states.resize(actor_count_spinbox.value)
	_state_buttons()


func _state_buttons():
	for i in states_v_box.get_children():
		states_v_box.remove_child(i)
		i.queue_free()
	
	var index:int = 0
	for i:Dictionary in states:
		var new_button:Button = Button.new()
		
		if i.has("name"):
			new_button.text = str(index) + " " + i.name
		else:
			new_button.text = str(index)
		
		new_button.button_down.connect(_load_state.bind(index))
		
		states_v_box.add_child(new_button)
		index += 1
