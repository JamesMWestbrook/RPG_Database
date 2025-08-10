@tool
extends TabContainer

@onready var traits_window: TraitsWindow = $TraitsWindow
@onready var actors: ActorEditor = $Characters/TabContainer/Actors

@onready var classes: ClassEditor = $Characters/TabContainer/Classes
@onready var enemies: Control = $Characters/TabContainer/Enemies
@onready var troops: Control = $Characters/TabContainer/Troops


func _ready() -> void:
	#actors.trait_container.traits_window = traits_window
	#actors.trait_container.ConnectButton.connect(traits_window._set_trait)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tab_container_tab_clicked(tab: int) -> void:
	print(str(tab))
	match tab:
		0: #load actor
			actors._load_actor(actors.cur_actor_index)
		1:
			pass
