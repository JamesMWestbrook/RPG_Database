extends VBoxContainer
class_name TroopLayoutSlot

var x:int
var y:int
var loading:bool

@export var x_spin_box:SpinBox
@export var y_spin_box:SpinBox

signal UpdatePosition(x, y)
signal UpdateSlots()

func _set_x_y(_x,_y):
	x = _x
	y = _y
func _on_x_spin_box_value_changed(value: float) -> void:
	if loading:
		return
	x = value
	_update_signal()

func _on_y_spin_box_value_changed(value: float) -> void:
	if loading:
		return
	y = value
	_update_signal()

func _update_signal():
	UpdatePosition.emit(x,y)
	UpdateSlots.emit()

func _on_delete_button_button_down() -> void:
	UpdateSlots.emit()
	queue_free()
