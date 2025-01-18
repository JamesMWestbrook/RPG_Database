@tool
extends Control

@onready var actor_container:VBoxContainer = $ScrollContainer/ActorsVBox
@onready var NameEdit = $NameLabel/NameEdit

const JSON_SAVE_PATH = "res://data/actors.json"

var cur_actor_index:int
var actors = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_check_json()
	NameEdit.text_changed.connect(_update_name)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var start_data = {
			actor_count = 5,
			actors = []
		}
		var index:int = 0
		for actor in start_data.actor_count:
			var new_button:Button = Button.new()
			actor_container.add_child(new_button)
			
			new_button.text = "Name Here"
			new_button.pressed.connect(_load_actor.bind(index))
			actors.append({})
			index += 1
			
func _load_json(file:FileAccess):
	pass
func _save_json():
	pass

func _load_actor(index:int):
	print("Actor " + str(index) + " selected")
	cur_actor_index = index

func _update_name(text):
	actors[cur_actor_index]["name"] = text
