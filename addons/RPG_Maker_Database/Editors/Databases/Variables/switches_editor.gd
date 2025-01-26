extends Control

const SAVE_PATH = "res://data/switches"
@export var switch_scene:PackedScene
@onready var switch_set_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer/Column1/SwitchSetContainer
@onready var switch_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer2/SwitchContainer

var switch_default_values = []
var switch_names = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		_load_json()
	else: #init data
		var max_amount = 20
		switch_default_values.resize(max_amount)
		switch_names.resize(max_amount)
		for i in max_amount:
			switch_default_values[i] = false
			switch_names[i] = ""
		_load_set(0)
		for i in 2:
			var new_button = Button.new()
			new_button.text = str(i * 20 + 1) + "-" + str(i * 20 + 20)
			switch_set_container.add_child(new_button)
			new_button.button_down.connect(_load_set.bind(i))

func _clear_switch_buttons():
	for i in switch_container.get_children():
		switch_container.remove_child(i)
		i.queue_free()
		
func _load_set(index:int):
	_clear_switch_buttons()
	var max = _get_number(index)
	for i in 20:
			
		var new_switch:Switch = switch_scene.instantiate()
		switch_container.add_child(new_switch)
		
	var i = 0
	for switch:Switch in switch_container.get_children(): 
		switch.label.text = str(20 * index + i + 1)
		switch.line_edit.text_changed.connect(_update_name.bind(i))
		switch.check_button.toggled.connect(_update_bool.bind(i))
		i += 1

func _update_bool(value:bool,index):
	switch_default_values[index] = value
func _update_name(text,index):
	switch_names[index] = text 
func _get_number(index:int):
	var number = index * 21
	
func _load_json():
	pass
	
func _save_json():
	pass
