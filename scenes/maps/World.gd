extends Node2D

signal location_change(name)
signal chest_opened(data)

onready var Chest = preload("res://scenes/items/Chest.tscn")

func _ready():
	var test_item_data = {"id": 1, "item": "Health Potion", "quantity": 1}
	var chest_pos = {"x": 472, "y": 265}
	if GameData.chests.has("1"):
		add_chest(null, chest_pos, 1, true)
	else:
		add_chest(test_item_data, chest_pos, 1, false)

	var test_item_data2 = {"id": 1, "item": "Health Potion", "quantity": 1}
	var chest_pos2 = {"x": 512, "y": 265}
	if GameData.chests.has("2"):
		add_chest(null, chest_pos2, 2, true)
	else:
		add_chest(test_item_data2, chest_pos2, 2, false)


func add_chest(item, pos, chest_id, is_opened):
	var chest = Chest.instance()
	chest.position.x = pos["x"]
	chest.position.y = pos["y"]
	if is_opened:
		chest.open()
	chest.items.append(item)
	chest.id = chest_id
	chest.connect("chest_opened", self, "on_chest_opened")
	get_node("chests").add_child(chest)


func _on_Town_body_entered(_body):
	print("town hit")
	emit_signal("location_change", "FirstTown")


func on_chest_opened(data):
	print("In World - Chest Opened")
	emit_signal("chest_opened", data)
