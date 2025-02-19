@tool
extends VBoxContainer
class_name TraitContainer

const TRAIT_ROW = preload("res://addons/RPG_Maker_Database/Editors/Databases/trait_row.tscn")
var traits_window:TraitsWindow


signal ConnectButton(button) 
signal UpdatedTraits(list)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_new():
	var new_trait:Trait = TRAIT_ROW.instantiate()
	add_child(new_trait)
	ConnectButton.emit(new_trait)
	new_trait.changed.connect(_update_list)
	#new_trait.button_down.connect(traits_window._set_trait.bind(new_button))
	
func _update_list():
	var traits:Array=[]
	for t:Trait in get_children():
		traits.append({
			"state":t.state,
			"argument":t.argument,
			"arg_value":t.argument_value
		})
	UpdatedTraits.emit(traits)
