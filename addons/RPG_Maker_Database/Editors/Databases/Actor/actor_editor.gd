@tool
extends Control
class_name ActorEditor

@export var clear_textures: bool:
	set(value):
		name_edit.text = ""
		nickname_edit.text = ""
		initial_level_edit.value = 0
		max_level_edit.value = 0
		profile_edit.text = ""
		face_sprite.texture = null
		walking_sprite.texture = null
		battler_sprite.texture = null
		
#region Onreadys
@onready var actor_container:VBoxContainer = $BoxContainer/Column1/ScrollContainer/ActorsVBox
@onready var name_edit:LineEdit = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer2/NameEdit
@onready var nickname_edit: LineEdit =$BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer2/NicknameEdit
@onready var initial_level_edit: SpinBox = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column3/InitialLevelEdit
@onready var max_level_edit: SpinBox = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column3/MaxLevelEdit
@onready var profile_edit: TextEdit = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/ProfileEdit

@onready var face_sprite: Sprite2D = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer3/FaceButton/FaceSprite
@onready var face_button: Button = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer3/FaceButton
@onready var face_index_spinbox: SpinBox = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer4/FaceIndexSpinbox

@onready var sprite_button: Button = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer3/SpriteButton
@onready var walking_sprite: Sprite2D = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer3/SpriteButton/WalkingSprite
@onready var sprite_index_spinbox: SpinBox = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer4/SpriteIndexSpinbox

@onready var battler_button: Button = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer3/BattlerButton
@onready var battler_sprite: Sprite2D = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer/Column2/HBoxContainer3/BattlerButton/BattlerSprite

@onready var trait_container: TraitContainer = $BoxContainer/ScrollColumn2/VBoxContainer/TraitContainer

@onready var menu_button: MenuButton = $BoxContainer/ScrollColumn2/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/MenuButton

#endregion

const JSON_SAVE_PATH = "res://data/actors.json"

var cur_actor_index:int
var actors:Array = []

var classes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	_load_classes()
	_check_json()
	sprite_index_spinbox.value_changed.connect(_sprite_index)
	_load_actor(0)
	menu_button.get_popup().index_pressed.connect(_select_class)
	
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
func _load_classes():
	var class_path = ClassEditor.JSON_SAVE_PATH
	if !FileAccess.file_exists(class_path):
		return
	var file = FileAccess.open(class_path,FileAccess.READ)
	classes = JSON.parse_string(file.get_as_text()).classes
#region load actor
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
	if actor.has("class"):
		menu_button.text = classes[actor.class].name
	else:
		actor.class = 0
		menu_button.text = classes[actor.class].name
		
	if actor.has("face") and actor["face"] != "":
		if FileAccess.file_exists(actor["face"]):
			face_sprite.texture = load(actor["face"])
			if actor.has("face_index"):
				face_index(actor["face_index"])
				face_index_spinbox.value = actor["face_index"]
				
			else:
				face_index(0)
				face_index_spinbox.value = 0
	else:
		face_sprite.texture = null
		actor["face"] = ""
		face_index(0)
		face_index_spinbox.value = 0
	if actor.has("walking_sprite"):
		var sprite_path:String = actor["walking_sprite"]
		walking_sprite.texture = load(sprite_path)
		if sprite_path.get_file().begins_with("$"):
			#if it starts with $ meaning a single sprite
			sprite_index_spinbox.hide()
		else:
			#full sprite sheet
			sprite_index_spinbox.show()
			walking_sprite.hframes = 12
			walking_sprite.vframes = 8
			walking_sprite.frame = 1
			if actor.has("walk_index"):
				_sprite_index(actor["walk_index"])
				sprite_index_spinbox.value = actor["walk_index"]
	else:
		walking_sprite.texture = null
		sprite_index_spinbox.hide()
	if actor.has("battler") and actor["battler"] != "":
		var path:String = actor["battler"]
		if FileAccess.file_exists(path):
			battler_sprite.texture = load(actor["battler"])
	else:
		battler_sprite.texture = null
		actor["battler"] = ""
#endregion

func _save_json():
	var save_data:Dictionary = {
		"max_actors" : actor_container.get_child_count(),
		"actors": actors
	}
	var json_string = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH,FileAccess.WRITE)
	file.store_string(json_string)
	
	
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
	
	


func face_selected(face_path:String):
	var new_face = load(face_path)
	face_sprite.texture = new_face
	actors[cur_actor_index]["face"] = face_path
func clear_actor_face():
	face_sprite.texture = null
	actors[cur_actor_index]["face"] = ""
func face_index(index:int):
	actors[cur_actor_index]["face_index"] = index
	face_sprite.frame = index

func sprite_selected(sprite_path:String):
	var new_sprite = load(sprite_path)
	walking_sprite.texture = new_sprite
	var file_name = sprite_path.get_file()
	if file_name.begins_with("$"):
		walking_sprite.hframes = 3
		walking_sprite.vframes = 4
		walking_sprite.frame = 1
		sprite_index_spinbox.hide()
		
	else:
		#filename does NOT start with $, a full spritesheet
		walking_sprite.hframes = 12
		walking_sprite.vframes = 8
		walking_sprite.frame = 1
		sprite_index_spinbox.show()

	
	actors[cur_actor_index]["walking_sprite"] = sprite_path
	
func clear_walking_sprite():
	walking_sprite.texture = null
	actors[cur_actor_index]["walking_sprite"] = ""
	sprite_index_spinbox.value = 0
func _sprite_index(index):
	actors[cur_actor_index]["walk_index"] = index
	if index < 4:
		walking_sprite.frame = 1 + 3 * index
	elif index > 3:
		walking_sprite.frame = 1 * 3  * index + (12 * 3)
	
func _battler_selected(path:String):
	actors[cur_actor_index]["battler"] = path
	battler_sprite.texture = load(path)
	
func _clear_battler():
	actors[cur_actor_index]["battler"] = ""
	battler_sprite.texture = null
	
func _load_class_list():
	pass
	
func _select_class(index:int):
	print(str(index) + " Selected")
	menu_button.text = classes[index].name
	actors[cur_actor_index].class = index


func _on_menu_button_button_down() -> void:
	menu_button.get_popup().clear()
	for c in classes:
		menu_button.get_popup().add_item(c.name)


func _on_trait_container_updated_traits(list: Variant) -> void:
	actors[cur_actor_index].traits = list
