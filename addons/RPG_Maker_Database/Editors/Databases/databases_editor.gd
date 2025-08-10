@tool
extends TabContainer

@onready var traits_window: TraitsWindow = $TraitsWindow

@onready var actors: ActorEditor = $Characters/CharTabContainer/Actors
@onready var classes: ClassEditor = $Characters/CharTabContainer/Classes
@onready var enemies: Control = $Characters/CharTabContainer/Enemies
@onready var troops: Control = $Characters/CharTabContainer/Troops

@onready var skills: SkillEditor = $Objects/ObjTabContainer/Skills


func _ready() -> void:
	#actors.trait_container.traits_window = traits_window
	#actors.trait_container.ConnectButton.connect(traits_window._set_trait)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_tab_container_tab_clicked(tab: int) -> void:
	print(str(tab))
	match tab:
		0: #load actor
			actors._load_actor(actors.cur_actor_index)
		1: #classes
			pass
		2: #enemies
			pass
		3: #troops
			pass


func _on_obj_tab_container_tab_clicked(tab: int) -> void:
	match tab:
		0: #Skills
			skills._load_skill(skills.cur_skill_index)
