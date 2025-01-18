@tool
extends EditorPlugin

const MainPanel = preload("res://addons/RPG_Maker_Database/Editors/Databases/DatabasesEditor.tscn")
var main_panel_instance
func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	_check_for_data_folder()
	_check_for_json_files()
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if main_panel_instance:
		main_panel_instance.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible
func _get_plugin_name():
	return "Databases"
func _check_for_data_folder():
	var dir = DirAccess.open("res://")
	if dir.dir_exists("data"):
		pass
	else:
		dir.make_dir("data")
	
func _check_for_json_files():
	pass
