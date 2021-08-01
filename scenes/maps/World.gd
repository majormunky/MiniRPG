extends Node2D

signal location_change(name)


func _ready():
	pass


func _on_Town_body_entered(_body):
	print("town hit")
	emit_signal("location_change", "FirstTown")
