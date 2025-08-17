@tool
extends Control
class_name TroopSetup

@export var troop_slot_scene:PackedScene
@export var troop_button_list:VBoxContainer
@export var max_spin_box:SpinBox
@export var battlefield:Node2D
@export var sample_enemy:PackedScene

static var slots:Array

const JSON_SAVE_PATH = "res://data/troop_layout.json"

signal SlotsUpdated()

func _ready() -> void:
	_check_json()
	await get_tree().process_frame
	_populate()

func _on_add_spawn_button_button_down() -> TroopLayoutSlot:
	var new_slot:TroopLayoutSlot = troop_slot_scene.instantiate()
	
	troop_button_list.add_child(new_slot)
	return new_slot
	
func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var enemy_count = 4
		slots.resize(enemy_count)
		for i in enemy_count:
			_check_slot(i)
		_save_json()
		
func _save_json() -> void:
	var save_data:Dictionary = {
		"slots" : slots
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	SlotsUpdated.emit()

func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	slots = save_data["slots"]
	max_spin_box.value = slots.size()
	
	for index in range(slots.size()):
		_check_slot(index)
	
	SlotsUpdated.emit()
	
func _on_change_slot_max_button_button_down() -> void:
	slots.resize(max_spin_box.value)
	for index in range(slots.size()):
		_check_slot(index)
	_populate()

func _check_slot(index:int):
	if slots[index] == null:
		slots[index] = {}
	var slot:Dictionary = slots[index]
	
	if slot.has("x"):
		return
	slot.x = 300
	slot.y = 300
	
	slots[index] = slot

func _populate():
	for i in troop_button_list.get_children():
		troop_button_list.remove_child(i)
		i.queue_free()
	for i in battlefield.get_children():
		battlefield.remove_child(i)
		i.queue_free()
		
	var index:int = 0
	for s:Dictionary in slots:
		var new_slot:TroopLayoutSlot = _on_add_spawn_button_button_down()
		new_slot.loading = true
		new_slot.x = s.x
		new_slot.x_spin_box.value = s.x
		new_slot.x_spin_box.max_value = DisplayServer.screen_get_size(0).x
		new_slot.y = s.y
		new_slot.y_spin_box.value = s.y
		new_slot.y_spin_box.max_value = DisplayServer.screen_get_size(0).y
		new_slot.loading = false
		var sprite = sample_enemy.instantiate()
		new_slot.connected_sprite = sprite
		sprite.texture = load("res://addons/eranot.resizable/icon.svg")
		battlefield.add_child(sprite)
		sprite.global_position.x = new_slot.x
		sprite.global_position.y = new_slot.y
		new_slot.UpdatePosition.connect(sprite._set_position)
		new_slot.UpdateSlots.connect(_update_slots)
		new_slot.UpdatePosition.emit(new_slot.x,new_slot.y)
		index += 1
		
func _update_slots():
	await get_tree().process_frame
	slots.clear()
	for i:TroopLayoutSlot in troop_button_list.get_children():
		slots.append({
			"x":i.x,
			"y":i.y
		})
