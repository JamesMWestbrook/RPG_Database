extends Control
class_name SkillEditor

#region onreadys
@onready var name_edit: LineEdit = $"ScrollContainer/BoxContainer/2nd Column/NameEdit"
@onready var skills_box: VBoxContainer = $"ScrollContainer/BoxContainer/1st Column/ScrollContainer/SkillsBox"
@onready var skill_count_spinbox: SpinBox = $"ScrollContainer/BoxContainer/1st Column/HBoxContainer2/SkillCountSpinbox"

@onready var skill_type: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Type&Cost/SkillTypeContainer/SkillType"


#endregion



var cur_skill_index:int
var skills:Array
const JSON_SAVE_PATH = "res://data/skills.json"

signal SkillsUpdated(skills)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	_check_json()
	#var button:Button = skills_box.get_child(0)
	#button.button_down.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		var skill_count = 5
		for i in skill_count:
			var new_skill:Dictionary = {}
			skills.append(new_skill)
			_check_skill(i)
		_skill_buttons()
		_save_json()
		
		
func _save_json() -> void:
	var save_data:Dictionary = {
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
	skill_count_spinbox.value = skills.size()
	
	for index in range(skills.size()):
		_check_skill(index)
	
	_skill_buttons()
	_load_skill(0)
	SkillsUpdated.emit()
	
func _load_skill(index:int):
	cur_skill_index = index
	var skill = skills[index]
	
	if skill.has("name"):
		name_edit.text = skill.name
	else:
		printerr("Skill has no info")
		
	#skill type
	skill_type.clear()
	skill_type.add_item("None")
	for type:String in TypesEditor.type_data[1]:
		skill_type.add_item(type)
	
	
	
func _check_skill(index:int): #Not assigning Dictionary as type since null is sometimes its type/value
	if skills[index] == null:
		skills[index] = {}
		
	if skills[index].has("name"):
		return
	else:
		skills[index].name = "Skill " + str(index)
		skills[index].description = ""
		skills[index].type = 0
		skills[index].mp_cost = 0
		skills[index].tp_cost = 0
		skills[index].hp_cost = 0
		skills[index].gold_cost = 0
		
		skills[index].scope_side = 0
		skills[index].scope_number = 0
		skills[index].random_count = 0
		skills[index].occasion = 0
		
		skills[index].speed = 0
		skills[index].success_rate = 100
		skills[index].repeat = 1
		skills[index].tp_gain = 0
		skills[index].hit_type = 0
		skills[index].animation = 0
		
		skills[index].message = ""
		
		skills[index].weapon_type_one = -1
		skills[index].weapon_type_two = -1
		
		skills[index].type = 0
		skills[index].element = 0
		skills[index].damage_formula = ""
		
		#effects are not yet implemented
	
func _skill_buttons():
	for i in skills_box.get_children():
		skills_box.remove_child(i)
		i.queue_free()
	
	var index:int = 0
	for s:Dictionary in skills:
		var hbox:HBoxContainer = HBoxContainer.new()
		var index_label:Label = Label.new()
		var new_button:Button = Button.new()
		
		
		hbox.add_child(index_label)
		hbox.add_child(new_button)
		
		skills_box.add_child(hbox)
		
		index_label.text = str(index)
		index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		index_label.custom_minimum_size.x = 13
		
		new_button.custom_minimum_size.x = 176.0
		if s.has("name"):
			new_button.text = s.name
		else:
			new_button.text = "Skill " + str(index)
		_check_skill(index)
		new_button.button_down.connect(_load_skill.bind(index))
		index += 1
	
func _update_name(text:String):
	skills[cur_skill_index].name = text
	skills_box.get_child(cur_skill_index).text = text


func _on_change_actor_max_button_down() -> void:
	skills.resize(skill_count_spinbox.value)
	for index in range(skills.size()):
		_check_skill(index)
	_skill_buttons()
