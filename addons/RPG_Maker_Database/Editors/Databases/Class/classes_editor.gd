@tool
extends Control

@export var clear_textures: bool:
	set(value):
		pass
		
		
@onready var traits_window: TraitsWindow 
@onready var classes_v_box: VBoxContainer = $"BoxContainer/1st Column/ScrollContainer/ClassesVBox"
@onready var name_edit: LineEdit = $"BoxContainer/2nd Column/NameEdit"

#region stats
@onready var hp_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/HPBox/HPStartSpinBox"
@onready var hp_end_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/HPBox/HPEndSpinBox"
@onready var mp_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/MPBox/MPStartSpinBox"
@onready var mp_end_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/MPBox/MPEndSpinBox"
@onready var atk_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/AttackBox/AtkStartSpinBox"
@onready var atk_end_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/AttackBox/AtkEndSpinBox"
@onready var def_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/DefenseBox/DefStartSpinBox"
@onready var def_end_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/DefenseBox/DefEndSpinBox"
@onready var mat_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/MAttackBox/MatStartSpinBox"
@onready var mat_end_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/MAttackBox/MatEndSpinBox"
@onready var m_def_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/MDefenseBox/MDefStartSpinBox"
@onready var m_def_endd_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/MDefenseBox/MDefEnddSpinBox"
@onready var agi_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/AgilityBox/AgiStartSpinBox"
@onready var agi_end_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/AgilityBox/AgiEndSpinBox"
@onready var lck_start_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/LuckBox/LckStartSpinBox"
@onready var lck_end_spin_box: SpinBox = $"BoxContainer/2nd Column/VBoxContainer/LuckBox/LckEndSpinBox"


#endregion 

const JSON_SAVE_PATH = "res://data/classes.json"

var cur_class_index:int
var classes:Array
var class_count:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_check_json()
	
	_load_class(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _check_json():
	if FileAccess.file_exists(JSON_SAVE_PATH):
		var file = FileAccess.open(JSON_SAVE_PATH,FileAccess.READ)
		_load_json(file)
	else:
		class_count = 5
		for i in class_count:
			var new_button:Button = Button.new()
			classes_v_box.add_child(new_button)
			
			new_button.text = "Class " + str(i)
			new_button.button_down.connect(_load_class.bind(i))
			classes.append({})
			
func _load_json(file:FileAccess):
	var json_string:String = file.get_as_text()
	var save_data:Dictionary = JSON.parse_string(json_string)
	classes = save_data["classes"]
	var index:int = 0
	for c in classes:
		var new_button:Button=Button.new()
		classes_v_box.add_child(new_button)
		if c.has("name"):
			new_button.text = c["name"]
		else:
			new_button.text = "Class " + str(index)
		_check_class(c)
		
		new_button.button_down.connect(_load_class.bind(index))
		index += 1
	_load_class_stats(classes[cur_class_index])
	
	
func _load_class(index:int):
	cur_class_index = index
	var rpg_class:Dictionary = classes[cur_class_index]
	if rpg_class.has("name"):
		name_edit.text = rpg_class["name"]
	else:
		name_edit.text = "Class " + str(index)
		_update_name("Class " + str(index))
	_check_class(classes[cur_class_index])
	_load_class_stats(classes[cur_class_index])
	
	
		
func _update_name(text:String):
	classes[cur_class_index]["name"] = text
	classes_v_box.get_child(cur_class_index).text = text
func _save_json():
	var save_data:Dictionary = {
		"class_count": classes_v_box.get_child_count(),
		"classes": classes
	}
	var json_string = JSON.stringify(save_data)
	var file:FileAccess = FileAccess.open(JSON_SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	
func _check_class(c:Dictionary):
	if c.has("start_hp"):
		pass
	else:
		c.start_hp = 15
		c.end_hp = 999
		c.start_mp = 20
		c.end_mp = 500
		c.start_atk = 5
		c.end_atk = 500
		c.start_def = 5
		c.end_def = 200
		c.start_mat = 5
		c.end_mat = 515
		c.start_mdf = 5
		c.end_mdf = 525
		c.start_agi = 5
		c.end_agi = 70
		c.start_lck = 5
		c.end_lck = 30
		
func _load_class_stats(c:Dictionary):
	hp_start_spin_box.value = c.start_hp
	hp_end_spin_box.value = c.end_hp
	mp_start_spin_box.value = c.start_mp
	mp_end_spin_box.value = c.end_mp
	atk_start_spin_box.value = c.start_atk
	atk_end_spin_box.value = c.end_atk
	def_start_spin_box.value = c.start_def
	def_end_spin_box.value = c.end_def
	mat_start_spin_box.value = c.start_mat
	mat_end_spin_box.value = c.end_mat
	m_def_start_spin_box.value = c.start_mdf
	m_def_endd_spin_box.value = c.end_mdf
	agi_start_spin_box.value = c.start_agi
	agi_end_spin_box.value = c.end_agi
	lck_start_spin_box.value = c.start_lck
	lck_end_spin_box.value = c.end_lck


func _on_hp_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_hp = value


func _on_hp_end_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_hp = value



func _on_mp_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_mp = value



func _on_mp_end_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_mp = value



func _on_atk_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_atk = value


func _on_atk_end_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_atk = value


func _on_def_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_def = value


func _on_def_end_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_def = value


func _on_mat_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_mat = value


func _on_mat_end_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_mat = value


func _on_m_def_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_mdf = value


func _on_m_def_endd_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_mdf = value


func _on_agi_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_agi = value


func _on_agi_end_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_agi = value


func _on_lck_start_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].start_lck = value


func _on_lck_end_spin_box_value_changed(value: float) -> void:
	classes[cur_class_index].end_lck = value
