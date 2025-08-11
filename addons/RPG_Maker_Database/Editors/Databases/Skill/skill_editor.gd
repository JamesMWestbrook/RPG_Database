extends Control
class_name SkillEditor

#region onreadys
@onready var name_edit: LineEdit = $"ScrollContainer/BoxContainer/2nd Column/NameEdit"
@onready var skills_box: VBoxContainer = $"ScrollContainer/BoxContainer/1st Column/ScrollContainer/SkillsBox"

@onready var skill_type: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Type&Cost/SkillTypeContainer/SkillType"


#endregion



var cur_skill_index:int
var skill_count:int
var skills:Array
const JSON_SAVE_PATH = "res://data/skills.json"

signal SkillsUpdated(skills)

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
			var new_skill:Dictionary = {}
			skills.append(new_skill)
			_check_skill(new_skill)
		_save_json()
		
func _save_json() -> void:
	var save_data:Dictionary = {
		"skill_count" : skills_box.get_child_count(),
		"skills" : skills
	}
	var json_string:String = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	SkillsUpdated.emit(skills)
	
	
func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	skills = save_data["skills"]
	_skill_buttons()
	_load_skill(0)
	SkillsUpdated.emit()
	
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
	if skill.has("name"):
		return
	else:
		skill.name = "Skill " + str(skills.find(skill))
		skill.description = ""
		skill.type = 0
		skill.mp_cost = 0
		skill.tp_cost = 0
		skill.hp_cost = 0
		skill.gold_cost = 0
		
		skill.scope_side = 0
		skill.scope_number = 0
		skill.random_count = 0
		skill.occasion = 0
		
		skill.speed = 0
		skill.success_rate = 100
		skill.repeat = 1
		skill.tp_gain = 0
		skill.hit_type = 0
		skill.animation = 0
		
		skill.message = ""
		
		skill.weapon_type_one = -1
		skill.weapon_type_two = -1
		
	
func _skill_buttons():
	for i in skills_box.get_children():
		skills_box.remove_child(i)
		i.queue_free()
	
	var index:int = 0
	for s:Dictionary in skills:
		var new_button:Button = Button.new()
		skills_box.add_child(new_button)
		if s.has("name"):
			new_button.text = s.name
		else:
			new_button.text = "Skill " + str(index)
		_check_skill(s)
		new_button.button_down.connect(_load_skill.bind(index))
		index += 1
	
func _load_skill_stats(skill:Dictionary):
	pass
	
func _update_name(text:String):
	skills[cur_skill_index].name = text
	skills_box.get_child(cur_skill_index).text = text
