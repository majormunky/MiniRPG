extends Node2D

signal location_change(name)
signal chest_opened(data)

onready var Chest = preload("res://scenes/items/Chest.tscn")

func _ready():
	var chest_pos = {"x": 472.524, "y": 265.533}
	var chest = Chest.instance()
	chest.position.x = chest_pos["x"]
	chest.position.y = chest_pos["y"]
	chest.items.append({"id": 1, "item": "Health Potion", "quantity": 1})
	chest.connect("chest_opened", self, "on_chest_opened")
	get_node("chests").add_child(chest)

func _on_Town_body_entered(_body):
	print("town hit")
	emit_signal("location_change", "FirstTown")


func on_chest_opened(data):
	print("In World - Chest Opened")
	emit_signal("chest_opened", data)
