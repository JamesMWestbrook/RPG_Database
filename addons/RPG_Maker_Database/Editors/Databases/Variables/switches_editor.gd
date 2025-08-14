extends Control
class_name Switches

const SAVE_PATH = "res://data/switches.json"
@export var switch_scene:PackedScene
@onready var switch_set_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer/Column1/SwitchSetContainer
@onready var switch_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer2/SwitchContainer
@onready var max_spin_box: SpinBox = $ScrollContainer/BoxContainer/ScrollContainer/Column1/HBoxContainer2/MaxSpinBox


var max_amount = 20
var switch_default_values = []
static var switch_names = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		_load_json()
	else: #init data
		switch_default_values.resize(max_amount)
		switch_names.resize(max_amount)
		for i in max_amount:
			switch_default_values[i] = false
			switch_names[i] = ""
		_load_set(0)
		_spawn_section_button()
		max_spin_box.value = max_amount
		
		

func _clear_switch_buttons():
	for i in switch_container.get_children():
		switch_container.remove_child(i)
		i.queue_free()
func _spawn_section_button():
	for i in switch_set_container.get_children():
		switch_set_container.remove_child(i)
		i.queue_free()
	var loop = true
	var i = 0
	while loop:
		if i * 20 > max_amount - 1:
			loop = false
		else:
			var new_button = Button.new()
			new_button.text = str(i * 20 + 1) + "-" + str(i * 20 + 20)
			switch_set_container.add_child(new_button)
			new_button.button_down.connect(_load_set.bind(i))
			i += 1
func _load_set(index:int):
	_clear_switch_buttons()
	for i in 20:
		var code_index = 20 * index + i
		if code_index >= max_amount:
			break
		var new_switch:Switch = switch_scene.instantiate()
		switch_container.add_child(new_switch)
		
	var i = 0
	for switch:Switch in switch_container.get_children(): 
		var face_index = 20 * index + i + 1
		var code_index = 20 * index + i
		switch.check_button.button_pressed = switch_default_values[code_index]
		switch.line_edit.text = switch_names[code_index]
		
		switch.label.text = str(face_index)
		print("Index: " + str(index) + " Value Index: " + str(face_index))
		switch.line_edit.text_changed.connect(_update_name.bind(face_index - 1))
		switch.check_button.toggled.connect(_update_bool.bind(face_index - 1))
		i += 1

func _update_bool(value:bool,index):
	switch_default_values[index] = value
func _update_name(text,index):
	switch_names[index] = text 
func _get_number(index:int):
	var number = index * 21
	
func _load_json():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	max_amount = data.max
	switch_names = data.switch_names
	switch_default_values = data.switch_defaults
	max_amount = data.max
	max_spin_box.value = max_amount
	_spawn_section_button()
	_load_set(0)
	
	
func _save_json():
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	var data = JSON.stringify({
		"max" : max_amount,
		"switch_names" : switch_names,
		"switch_defaults" : switch_default_values
	})
	file.store_string(data)

func _on_resize_button_button_down() -> void:
	await get_tree().process_frame
	var value = max_spin_box.value
	max_amount = value
	_spawn_section_button()
	_load_set(0)
	switch_default_values.resize(max_amount)
	switch_names.resize(max_amount)
	_check_arrays()
	
func _check_arrays():
	for i in max_amount:
		var value = switch_default_values[i]
		if value == null:
			switch_default_values[i] = false
		var switch_name = switch_names[i]
		if switch_name == null:
			switch_names[i] = ""
		
		
