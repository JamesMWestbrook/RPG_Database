@tool
extends Control


#region #onreadys
@onready var actor_count_spinbox: SpinBox = $BoxContainer/Column1/ActorCountSpinbox
@onready var states_v_box: VBoxContainer = $BoxContainer/Column1/ScrollContainer/StatesVBox

@onready var name_line_edit: LineEdit = $BoxContainer/Column2Scroll/VBox/HBox2/NameLineEdit

#endregion
const SAVE_PATH = "res://data/states.json"

var states:Array[Dictionary]
var cur_state_index:int

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


func _check_state(index:int):
	pass
	
	
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
		index += 1
		
		new_button.button_down.connect(_load_state.bind(index))
		
		states_v_box.add_child(new_button)
