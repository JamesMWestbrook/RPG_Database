extends Control
class_name SkillEditor

#region onreadys
@onready var name_edit: LineEdit = $"ScrollContainer/BoxContainer/2nd Column/NameEdit"
@onready var skills_box: VBoxContainer = $"ScrollContainer/BoxContainer/1st Column/ScrollContainer/SkillsBox"
@onready var skill_count_spinbox: SpinBox = $"ScrollContainer/BoxContainer/1st Column/HBoxContainer2/SkillCountSpinbox"
@onready var description_edit: TextEdit = $"ScrollContainer/BoxContainer/2nd Column/DescriptionEdit"
@onready var message_edit: LineEdit = $"ScrollContainer/BoxContainer/2nd Column/MessageEdit"
@onready var formula_editor: CodeEdit = $"ScrollContainer/BoxContainer/3rd Column/FormulaEditor"
@onready var skill_icon: TextureRect = $"ScrollContainer/BoxContainer/2nd Column/Name&Icon/SkillIcon"
@onready var skill_type: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Type&Cost/SkillTypeContainer/SkillType"
@onready var mp_cost_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Type&Cost/MPCostContainer/MPCostSpinBox"
@onready var tp_cost_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Type&Cost/TPCostContainer/TPCostSpinBox"
@onready var hp_cost_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Type&Cost/HPCostContainer2/HPCostSpinBox"
@onready var gold_cost_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Type&Cost/GoldCostContainer2/GoldCostSpinBox"
@onready var scope_option_button: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Scope Row/ScopeContainer/ScopeOptionButton"
@onready var number_option: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Scope Row/NumberColumn/NumberOption"
@onready var random_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Scope Row/NumberColumn/RandomSpinBox"
@onready var occaison_spin_box: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Scope Row/OccasionContainer/OccaisonSpinBox"
@onready var weapon_one_option_button: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Scope Row/VBoxContainer/VBoxContainer2/Row8/WeaponOneOptionButton"
@onready var weapon_two_option_button: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Scope Row/VBoxContainer/VBoxContainer2/Row8/WeaponTwoOptionButton"
@onready var speed_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Invocation Row/Container/SpeedSpinBox"
@onready var success_rate_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Invocation Row/Container2/SuccessRateSpinBox"
@onready var repeat_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Invocation Row/Container3/RepeatSpinBox"
@onready var tp_gain_spin_box: SpinBox = $"ScrollContainer/BoxContainer/2nd Column/Invocation Row/Container4/TPGainSpinBox"
@onready var hit_type_option_button: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Invocation Row/HitTypeContainer/HitTypeOptionButton"
@onready var animation_option_button: OptionButton = $"ScrollContainer/BoxContainer/2nd Column/Invocation Row/AnimationContainer/AnimationOptionButton"
@onready var damage_type_option_button: OptionButton = $"ScrollContainer/BoxContainer/3rd Column/Row9/Box/DamageTypeOptionButton"
@onready var element_type_option_button: OptionButton = $"ScrollContainer/BoxContainer/3rd Column/Row9/Box2/ElementTypeOptionButton"

#endregion

var cur_skill_index:int
static var skills:Array
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
	var skill:Dictionary = skills[index]
	

	#Everything that should be loaded before loading the skill
	#skill type
	skill_type.clear()
	skill_type.add_item("None")
	for type:String in TypesEditor.type_data[1]:
		skill_type.add_item(type)
		
	element_type_option_button.clear()
	element_type_option_button.add_item("Normal")
	element_type_option_button.add_item("None")
	for type:String in TypesEditor.type_data[0]:
		element_type_option_button.add_item(type)

	#loading skill
	if skill.has("name"):
		name_edit.text = skill.name
	else:
		printerr("Skill has no info")
	
	if skill.icon != "":
		skill_icon.texture = load(skill.icon)
	description_edit.text = skill.description
	skill_type.select(skill.type)
	mp_cost_spin_box.value = skill.mp_cost
	tp_cost_spin_box.value = skill.tp_cost
	hp_cost_spin_box.value = skill.hp_cost
	gold_cost_spin_box.value = skill.gold_cost
	
	scope_option_button.select(skill.scope_side)
	number_option.select(skill.scope_number)
	if skill.scope_number == 2:
		random_spin_box.value = skill.random_count
	else:
		random_spin_box.value = 1
	occaison_spin_box.select(skill.occasion)
	
	weapon_one_option_button.select(skill.weapon_type_one + 1)
	weapon_two_option_button.select(skill.weapon_type_two + 1)
	
	speed_spin_box.value = skill.speed
	success_rate_spin_box.value = skill.success_rate
	repeat_spin_box.value = skill.repeat
	tp_gain_spin_box.value = skill.tp_gain
	hit_type_option_button.select(skill.hit_type)
	animation_option_button.select(skill.animation)
	
	message_edit.text = skill.message
	
	damage_type_option_button.select(skill.damage_type)
	element_type_option_button.select(skill.element + 2)
	formula_editor.text = skill.damage_formula
	
	
func _check_skill(index:int): #Not assigning Dictionary as type since null is sometimes its type/value
	if skills[index] == null:
		skills[index] = {}
		
	if skills[index].has("name"):
		return
	else:
		skills[index].name = "Skill " + str(index)
		skills[index].icon = ""
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
		
		skills[index].damage_type = 0
		skills[index].element = 0
		skills[index].damage_formula = "a.atk * 4 - b.def * 2"
		
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

func _on_change_actor_max_button_down() -> void:
	skills.resize(skill_count_spinbox.value)
	for index in range(skills.size()):
		_check_skill(index)
	_skill_buttons()

func _update_name(text:String):
	skills[cur_skill_index].name = text
	skills_box.get_child(cur_skill_index).get_child(1).text = text

func _on_description_edit_text_changed() -> void:
	skills[cur_skill_index].description = description_edit.text

func _on_skill_type_item_selected(index: int) -> void:
	skills[cur_skill_index].type = index

func _on_mp_cost_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].mp_cost = value

func _on_tp_cost_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].tp_cost = value


func _on_hp_cost_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].hp_cost = value

func _on_gold_cost_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].gold_cost = value


func _on_scope_option_button_item_selected(index: int) -> void:
	skills[cur_skill_index].scope_side = index

func _on_number_option_item_selected(index: int) -> void:
	skills[cur_skill_index].scope_number = 0
	
	random_spin_box.editable = false
	if index == 2:
		random_spin_box.editable = true

func _on_random_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].random_count = value

func _on_occaison_spin_box_item_selected(index: int) -> void:
	skills[cur_skill_index].occaison = index

#these subtract 1 bc there is an extra item inserted at start to account for "None"
#Loading this will add 1 to counteract it
func _on_weapon_one_option_button_item_selected(index: int) -> void:
	skills[cur_skill_index].weapon_type_one = index - 1

func _on_weapon_two_option_button_item_selected(index: int) -> void:
	skills[cur_skill_index].weapon_type_two = index - 1

func _on_speed_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].speed = value

func _on_success_rate_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].success_rate = value

func _on_repeat_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].repeat = value

func _on_tp_gain_spin_box_value_changed(value: float) -> void:
	skills[cur_skill_index].tp_gain = value

func _on_hit_type_option_button_item_selected(index: int) -> void:
	skills[cur_skill_index].hit_type = index

func _on_animation_option_button_item_selected(index: int) -> void:
	skills[cur_skill_index].animation = index

func _on_message_edit_text_changed(new_text: String) -> void:
	skills[cur_skill_index].message = new_text

func _on_damage_type_option_button_item_selected(index: int) -> void:
	skills[cur_skill_index].damage_type = index

func _on_element_type_option_button_item_selected(index: int) -> void:
	skills[cur_skill_index].element = index - 2

func _on_formula_editor_text_changed() -> void:
	skills[cur_skill_index].damage_formula = formula_editor.text


func _on_casts_button_button_down() -> void:
	message_edit.text = "%1 casts %2!"
	message_edit.text_changed.emit(message_edit.text)

func _on_does_button_button_down() -> void:
	message_edit.text = "%1 does %2!"
	message_edit.text_changed.emit(message_edit.text)

func _on_uses_button_button_down() -> void:
	message_edit.text = "%1 uses %2!"
	message_edit.text_changed.emit(message_edit.text)
