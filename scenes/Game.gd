extends Node2D


onready var world_manager = $WorldManager
onready var menu = $CanvasLayer/Menu
onready var dialog = $CanvasLayer/Dialog
onready var player = $Player
onready var transition_rect = $CanvasLayer/TransitionRect

func _ready():
	print("Game Starting")
	print("Player Name:", PlayerData.player_name)

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


func _on_WorldManager_before_map_change():
	transition_rect.fadeIn()
	get_tree().paused = true


func _on_WorldManager_after_map_change():
	transition_rect.fadeOut()
	get_tree().paused = false
