@tool
extends GridContainer

signal UpdatedSkills(list)

const SKILL_LEARN_SLOT = preload("res://addons/RPG_Maker_Database/Editors/Databases/Class/skill_learn_slot.tscn")

var loading:bool

func add_new(loading:bool = false):
	var new_skill = SKILL_LEARN_SLOT.instantiate()
	add_child(new_skill)
	new_skill.changed.connect(_update_list)
	if not loading:
		new_skill.changed.emit()
	return new_skill
	
func _update_list():
	if loading:
		return
	var skills:Array
	for s in get_children():
		if s.do_not_count_me:
			continue
		skills.append({
			"skill" : s.skill_index,
			"level_learned" : s.level_learned
		})
	UpdatedSkills.emit(skills)

func _clear():
	for i in get_children():
		remove_child(i)
		i.queue_free()

func _load_skills(skills):
	loading = true
	var i:int = 0
	for s in skills:
		var new_skill = add_new(true) 
		new_skill._on_skill_option_button_button_down()
		new_skill._load_skill(s.skill)
		new_skill.selected_index = s.skill
		new_skill.skill_index = s.skill
		#new_skill._on_level_spin_box_value_changed(s.level_learned)
		new_skill.level_spin_box.value = s.level_learned
	#_update_list()
	loading = false
