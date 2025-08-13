extends Control

#region
@export var texture:TextureRect
@export var default_image = load("res://addons/RPG_Maker_Database/Editors/DefaultImage.png")
@export var enemy_scene_path:Label
#endregion

var enemies:Array
var cur_enemy_index:int

signal EnemiesUpdated(enemies)

func _on_texture_file_dialog_file_selected(path: String) -> void:
	if path.get_extension() == "png":
		texture.texture = load(path)
	if path.get_extension() == "tscn":
		texture.texture = null
		enemy_scene_path.text = path.get_file()
