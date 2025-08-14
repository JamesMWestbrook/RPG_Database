#@tool
extends Control

const SAVE_PATH = "res://data/variables.json"
@export var variable_scene:PackedScene
@onready var max_spin_box: SpinBox = $ScrollContainer/BoxContainer/ScrollContainer/Column1/HBoxContainer2/MaxSpinBox
@onready var resize_button: Button = $ScrollContainer/BoxContainer/ScrollContainer/Column1/HBoxContainer2/ResizeButton
@onready var var_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer2/VarContainer
@onready var var_set_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer/Column1/VarSetContainer

var max_amount = 20
var var_default_values = []
var var_names = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		_load_json()
	else: #init data
		var_default_values.resize(max_amount)
		var_names.resize(max_amount)
		for i in max_amount:
			var_default_values[i] = 0
			var_names[i] = ""
		_load_set(0)
		_spawn_section_buttons()
		max_spin_box.value = max_amount


func _load_json():
	var file:FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	max_amount = data.max
	var_names = data.var_names
	var_default_values = data.var_defaults
	max_spin_box.value = max_amount
	_spawn_section_buttons()
	_load_set(0)

func _save_json():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = JSON.stringify({
		"max": max_amount,
		"var_names": var_names,
		"var_defaults": var_default_values
	})
	file.store_string(data)

func _load_set(index:int):
	for i in var_container.get_children():
		var_container.remove_child(i)
		i.queue_free()
	for i in 20:
		var code_index = 20 * index + i
		if code_index >= max_amount:
			break
		var new_var:Variable = variable_scene.instantiate()
		var_container.add_child(new_var)
		
	var i = 0
	for variable:Variable in var_container.get_children():
		var face_index = 20 * index + i + 1
		var code_index = 20 * index + i
		variable.value_line_edit.text = str(var_default_values[code_index])
		variable.line_edit.text = var_names[code_index]
		
		variable.label.text = str(face_index)
		
		variable.line_edit.text_changed.connect(_update_name.bind(code_index))
		variable.value_line_edit.text_changed.connect(_update_value.bind(code_index))
		i += 1
		
func _spawn_section_buttons():
	for i in var_set_container.get_children():
		var_set_container.remove_child(i)
		i.queue_free()
	var loop = true
	var i = 0
	while loop:
		if i * 20 > max_amount - 1:
			loop = false
		else:
			var new_button:Button = Button.new()
			new_button.text = str(i * 20 + 1) + "-" + str(i * 20 + 20)
			var_set_container.add_child(new_button)
			new_button.button_down.connect(_load_set.bind(i))
			i += 1
func _on_resize_button_button_down() -> void:
	await get_tree().process_frame
	var value = max_spin_box.value
	max_amount = value
	var_default_values.resize(max_amount)
	var_names.resize(max_amount)
	_check_arrays()
	
	_spawn_section_buttons()
	_load_set(0)
	

func _update_name(text:String, index:int):
	var_names[index] = text
	
func _update_value(text:String, index:int):
	var_default_values[index] = text
	
func _check_arrays():
	for i in max_amount:
		var value = var_default_values[i]
		if value == null:
			var_default_values[i] = 0
		var var_name = var_names[i]
		if var_name == null:
			var_names[i] = ""
	
