@tool
extends TabContainer

@onready var traits_window: TraitsWindow = $TraitsWindow
@onready var actors: ActorEditor = $Characters/TabContainer/Actors



func _ready() -> void:
	#actors.trait_container.traits_window = traits_window
	#actors.trait_container.ConnectButton.connect(traits_window._set_trait)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
