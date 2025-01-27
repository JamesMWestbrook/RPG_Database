extends Control

const SAVE_PATH = "res://data/variables.json"
@export var variable_scene:PackedScene
@onready var switch_set_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer/Column1/SwitchSetContainer
@onready var switch_container: VBoxContainer = $ScrollContainer/BoxContainer/ScrollContainer2/SwitchContainer
@onready var max_spin_box: SpinBox = $ScrollContainer/BoxContainer/ScrollContainer/Column1/HBoxContainer2/MaxSpinBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
