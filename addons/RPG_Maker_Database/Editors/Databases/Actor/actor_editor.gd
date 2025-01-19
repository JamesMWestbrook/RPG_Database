@tool
extends Control

@onready var save_button: Button = $SaveButton
@onready var actor_container:VBoxContainer = $ScrollContainer/ActorsVBox
@onready var name_edit:LineEdit = $NameLabel/NameEdit
@onready var nickname_edit: LineEdit = $NicknameLabel/NicknameEdit
@onready var initial_level_edit: SpinBox = $InitialLevelLabel/InitialLevelEdit
@onready var max_level_edit: SpinBox = $MaxLevelLabel/MaxLevelEdit
@onready var profile_edit: TextEdit = $ProfileLabel/ProfileEdit


const JSON_SAVE_PATH = "res://data/actors.json"

var cur_actor_index:int
var actors = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_check_json()
	
	save_button.pressed.connect(_save_json)
	name_edit.text_changed.connect(_update_name)
	nickname_edit.text_changed.connect(_update_nickname)
	initial_level_edit.value_changed.connect(_start_level)
	max_level_edit.value_changed.connect(_max_level)
	profile_edit.text_changed.connect(_profile)
	
	_load_actor(0)
	
	
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
			
			new_button.text = "Actor " + str(index)
			new_button.pressed.connect(_load_actor.bind(index))
			actors.append({})
			index += 1
	
		
func _load_json(file:FileAccess):
	var save_data:Dictionary
	var json_string:String = file.get_as_text()
	save_data = JSON.parse_string(json_string)
	actors = save_data["actors"]
	var index:int = 0
	for actor:Dictionary in actors:
		var new_button:Button = Button.new()
		actor_container.add_child(new_button)
		
		if actor.has("name"):
			new_button.text = actor["name"]
		else:
			new_button.text = "Actor " + str(index)
		
		new_button.pressed.connect(_load_actor.bind(index))
		index += 1
	
func _load_actor(index:int):
	print("Actor " + str(index) + " selected")
	cur_actor_index = index
	var actor:Dictionary = actors[cur_actor_index]
	if actor.has("name"):
			name_edit.text = actor["name"]
	else:
			name_edit.text = "Actor " + str(index)
			_update_name("Actor " + str(index))
		
	if actor.has("nickname"):
			nickname_edit.text= actor["nickname"]
	else:
		nickname_edit.text = ""
		_update_nickname("")
	if actor.has("start_level"):
		initial_level_edit.value = actor["start_level"]
	else:
		initial_level_edit.value = 1
		_start_level(1)
	if actor.has("max_level"):
		max_level_edit.value = actor["max_level"]
	else:
		max_level_edit.value = 99
		_max_level(99)
	if actor.has("profile"):
		profile_edit.text = actor["profile"]
	else:
		profile_edit.text = ""
		_profile()
			
func _update_name(text):
	actors[cur_actor_index]["name"] = text
	actor_container.get_child(cur_actor_index).text = text
	
func _update_nickname(text):
	actors[cur_actor_index]["nickname"] = text
	
func _start_level(index):
	actors[cur_actor_index]["start_level"] = index
	
func _max_level(index):
	actors[cur_actor_index]["max_level"] = index
func _profile():
	actors[cur_actor_index]["profile"] = profile_edit.text
	
	
func _save_json():
	var save_data:Dictionary = {
		"max_actors" : actor_container.get_child_count(),
		"actors": actors
	}
	var json_string = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH,FileAccess.WRITE)
	file.store_string(json_string)
