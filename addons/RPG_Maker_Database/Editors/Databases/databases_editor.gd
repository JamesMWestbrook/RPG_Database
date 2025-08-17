@tool
extends TabContainer

@onready var traits_window: TraitsWindow = $TraitsWindow

@onready var actors: ActorEditor = $Characters/CharTabContainer/Actors
@onready var classes: ClassEditor = $Characters/CharTabContainer/Classes
@onready var enemies: EnemyEditor = $Characters/CharTabContainer/Enemies
@onready var troops: Troops = $Characters/CharTabContainer/Troops

@onready var skills: SkillEditor = $Objects/ObjTabContainer/Skills
@onready var items: Items = $Objects/ObjTabContainer/Items
@onready var weapons: Weapons = $Objects/ObjTabContainer/Weapons
@onready var armors: Armors = $Objects/ObjTabContainer/Armors
@onready var states: States = $Objects/ObjTabContainer/States


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
			classes._load_class(classes.cur_class_index)
		2: #enemies
			enemies._load_enemy(enemies.cur_enemy_index)
		3: #troops
			troops._load_troop(troops.cur_troop_index)


func _on_obj_tab_container_tab_clicked(tab: int) -> void:
	match tab:
		0: #Skills
			skills._load_skill(skills.cur_skill_index)
		1: #Items
			items._load_item(items.cur_item_index)
		3: #Weapons
			weapons._load_weapon(weapons.cur_weapon_index)
		4: #Armors
			armors._load_armor(armors.cur_armor_index)
		5: #States
			states._load_state(states.cur_state_index)
