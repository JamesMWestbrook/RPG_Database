@tool
extends VBoxContainer
class_name TraitContainer

const TRAIT_BUTTON_SCENE = preload("res://addons/RPG_Maker_Database/Editors/Databases/trait_button.tscn")
var traits_window:TraitsWindow

var traits:Array=[]

signal ConnectButton(button) 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_new():
	var new_button = TRAIT_BUTTON_SCENE.instantiate()
	add_child(new_button)
	ConnectButton.emit(new_button)
	new_button.button_down.connect(traits_window._set_trait.bind(new_button))
	
func _update_list():
	traits.clear()
	for t:TraitButton in get_children():
		traits.append(t.rpg_trait)
