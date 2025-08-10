@tool
extends VBoxContainer
class_name TraitContainer

const TRAIT_ROW = preload("res://addons/RPG_Maker_Database/Editors/Databases/trait_row.tscn")
# var traits_window:TraitsWindow


signal ConnectButton(button) 
signal UpdatedTraits(list)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
func _add_new(loading:bool = false) -> Trait:
	var new_trait:Trait = TRAIT_ROW.instantiate()
	add_child(new_trait)
	ConnectButton.emit(new_trait)
	new_trait.changed.connect(_update_list)
	if not loading:
		new_trait.changed.emit()
	return new_trait
	#new_trait.button_down.connect(traits_window._set_trait.bind(new_button))
	
func _update_list():
	var traits:Array=[]
	for t:Trait in get_children():
		if t.do_not_count_me:
			continue
		traits.append({
			"state":t.state,
			"argument":t.argument,
			"arg_value":t.argument_value
		})
	UpdatedTraits.emit(traits)

func _load_traits(traits:Array):
	var i = 0
	for t in traits:
		var new_trait:Trait = _add_new(true)
		new_trait._on_function_option_item_selected(t.state, t.argument,t.arg_value)
	_update_list()


func _on_traits_help_button_down() -> void:
	OS.shell_open("https://www.rpgmakerweb.com/blog/a-primer-on-database-traits-and-effects")
