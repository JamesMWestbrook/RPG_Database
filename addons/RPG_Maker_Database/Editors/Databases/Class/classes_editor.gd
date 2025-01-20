@tool
extends Control

@export var clear_textures: bool:
	set(value):
		pass
		
		
@onready var traits_window: TraitsWindow 
@onready var classes_v_box: VBoxContainer = $"BoxContainer/1st Column/ScrollContainer/ClassesVBox"
@onready var name_edit: LineEdit = $"BoxContainer/2nd Column/NameEdit"

const JSON_SAVE_PATH = "res://data/classes.json"

var cur_class_index:int
var classes:Array
var class_count:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_check_json()
	
	_load_class(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		class_count = 5
		for i in class_count:
			var new_button:Button = Button.new()
			classes_v_box.add_child(new_button)
			
			new_button.text = "Class " + str(i)
			new_button.button_down.connect(_load_class.bind(i))
			classes.append({})
			
func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	classes = save_data["classes"]
	var index:int = 0
	for c in classes:
		var new_button:Button=Button.new()
		classes_v_box.add_child(new_button)
		if c.has("name"):
			new_button.text = c["name"]
		else:
			new_button.text = "Class " + str(index)
		new_button.button_down.connect(_load_class.bind(index))
		index += 1
	
func _load_class(index:int):
	cur_class_index = index
	var rpg_class:Dictionary = classes[cur_class_index]
	if rpg_class.has("name"):
		name_edit.text = rpg_class["name"]
	else:
		name_edit.text = "Class " + str(index)
		_update_name("Class " + str(index))
	
	
		
func _update_name(text:String):
	classes[cur_class_index]["name"] = text
	classes_v_box.get_child(cur_class_index).text = text
func _save_json():
	var save_data:Dictionary = {
		"class_count": classes_v_box.get_child_count(),
		"classes": classes
	}
	var json_string = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	
