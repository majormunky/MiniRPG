extends Node2D

signal location_change(name)


func _ready():
	pass
	

func _on_TownExit_body_entered(body):
	emit_signal("location_change", "World")
