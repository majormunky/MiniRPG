extends Node2D

signal location_change(name)
signal chest_opened(data)

func _ready():
	pass


func _on_Town_body_entered(_body):
	print("town hit")
	emit_signal("location_change", "FirstTown")


func _on_Chest_chest_opened(data):
	emit_signal("chest_opened", data)
