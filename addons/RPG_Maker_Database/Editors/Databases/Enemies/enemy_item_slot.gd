@tool
extends HBoxContainer

signal Updated


var updating:bool
var skip_me:bool

@onready var type: OptionButton = $Type
@onready var item: OptionButton = $Item
@onready var probability: SpinBox = $Probability



func _init_data(type_index:int, item_index:int, prob:int, loading:bool):
	updating = true
	type.select(type_index)
	_fill_item_list()
	item.select(item_index)
	probability.value = prob
	updating = false
	if loading:
		Updated.emit()
	
func _fill_item_list():
	item.clear()
	match type.selected:
		0: #Item
			var items = Items.items
			for i in items:
				item.add_item(i.name)
		1: #Weapon
			var weapons = Weapons.weapons
			for w in weapons:
				item.add_item(w.name)
		2: #Armor
			var armor = Armors.armors
			for a in armor:
				item.add_item(a.name)
	


func _on_type_item_selected(index: int) -> void:
	if updating:
		return
	Updated.emit()


func _on_item_item_selected(index: int) -> void:
	if updating:
		return
	Updated.emit()


func _on_probability_value_changed(value: float) -> void:
	if updating:
		return
	Updated.emit()


func _on_item_button_down() -> void:
	var index:int = item.selected
	_fill_item_list()
	item.select(index)


func _on_delete_button_down() -> void:
	skip_me = true
	Updated.emit()
	queue_free()
