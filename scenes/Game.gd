extends Node2D


onready var world_manager = $WorldManager
onready var menu = $CanvasLayer/Menu
onready var dialog = $CanvasLayer/Dialog
onready var player = $Player

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
	elif event.is_action_pressed("inspect"):
		if dialog.visible:
			dialog.visible = false
		else:
			# set the dialog text to our player position to help debug
			dialog.set_content("x: " + str(player.position.x) + "\ny: " + str(player.position.y))
			dialog.visible = true
		print("inspect")


func _on_WorldManager_new_player_position(data):
	print("in game.gd setting new player position")
	get_node("Player").position.x = data.x
	get_node("Player").position.y = data.y
