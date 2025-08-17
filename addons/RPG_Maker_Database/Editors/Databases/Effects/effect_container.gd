@tool
extends VBoxContainer
class_name EffectContainer
const EFFECT_ROW = preload("res://addons/RPG_Maker_Database/Editors/Databases/Effects/effect_row.tscn")
signal UpdatedEffects(list)

func _clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
func _add_new(loading:bool = false) -> Effect:
	var new_effect:Effect = EFFECT_ROW.instantiate()
	add_child(new_effect)
	new_effect.Changed.connect(_update_list)
	if not loading:
		new_effect.Changed.emit()
	return new_effect

func _update_list():
	var effects:Array=[]
	for e:Effect in get_children():
		if e.do_not_count_me:
			continue
		effects.append({
			"state":e.state,
			"argument":e.argument,
			"arg_value1":e.argument_value1,
			"arg_value2":e.argument_value2
		})
	UpdatedEffects.emit(effects)

func _load(effects:Array):
	var i = 0
	for e in effects:
		var new_effect:Effect = _add_new(true)
		new_effect._on_main_option_button_item_selected(e.state, e.argument,e.arg_value1,e.arg_value2)
	_update_list()
