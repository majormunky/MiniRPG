extends Node2D


onready var world_manager = $WorldManager
onready var menu = $Menu

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("menu"):
		if menu.visible:
			print("open menu")
			menu.visible = false
			get_tree().paused = false
		else:
			menu.visible = true
			get_tree().paused = true
			
