@tool
extends Button
class_name TraitButton

var rpg_trait = {
	"trait": "", #example, "ex-parameter"
	"argument":"", #example, 0 which means max_HP
	"modifier":"" #example, 120 means times 120%
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
