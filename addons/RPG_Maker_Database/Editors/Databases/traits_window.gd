extends Window
class_name TraitsWindow

var current_trait: TraitButton #Current trait button
								#being modified


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:#element rate
			pass
		1: #debuff rate
			pass
		2:
			pass
