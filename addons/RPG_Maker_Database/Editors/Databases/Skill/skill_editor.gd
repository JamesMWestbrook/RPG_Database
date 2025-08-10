extends Control
class_name SkillEditor

#region onreadys
@onready var name_edit: LineEdit = $"ScrollContainer/BoxContainer/2nd Column/NameEdit"
@onready var skills_box: VBoxContainer = $"ScrollContainer/BoxContainer/1st Column/ScrollContainer/SkillsBox"

@onready var skill_type: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Row2/SkillTypeContainer/SkillType"


#endregion



var cur_skill_index:int
var skill_count:int
var skills:Array
const JSON_SAVE_PATH = "res://data/skills.json"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	_check_json()
	var button:Button = skills_box.get_child(0)
	button.button_down.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		skill_count = 5
		for i in skill_count:
			var new_button:Button = Button.new()
			skills_box.add_child(new_button)
			
			new_button.text = "Skill " + str(i)
			skills.append({})
			new_button.button_down.connect(_load_skill.bind(i))
			
func _load_json(index:int):
	pass
	
func _load_skill(index:int):
	cur_skill_index = index
	var skill = skills[index]
	
	if skill.has("name"):
		name_edit.text = skill.name
	else:
		name_edit.text = "Skill " + str(index)
		_update_name(name_edit.text)
		
	#skill type
	skill_type.clear()
	skill_type.add_item("None")
	for type:String in TypesEditor.type_data[1]:
		skill_type.add_item(type)
	
		
	_check_skill(skills[cur_skill_index])
	_load_skill_stats(skills[cur_skill_index])
	
func _check_skill(skill:Dictionary):
	pass
func _load_skill_stats(skill:Dictionary):
	pass
func _update_name(text:String):
	skills[cur_skill_index].name = text
	skills_box.get_child(cur_skill_index).text = text
