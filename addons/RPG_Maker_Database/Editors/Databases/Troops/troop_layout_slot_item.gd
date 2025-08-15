extends VBoxContainer
class_name TroopLayoutSlot

var x:int
var y:int
@export var x_spin_box:SpinBox
@export var y_spin_box:SpinBox

signal UpdatePosition(x, y)
signal UpdateSlots()


func _on_x_spin_box_value_changed(value: float) -> void:
	x = value
	_update_signal()

func _on_y_spin_box_value_changed(value: float) -> void:
	y = value
	_update_signal()

func _update_signal():
	UpdatePosition.emit(x,y)
	UpdateSlots.emit()

func _on_delete_button_button_down() -> void:
	pass # Replace with function body.
