extends Node2D


onready var world_manager = $WorldManager
onready var menu = $CanvasLayer/Menu
onready var dialog = $CanvasLayer/Dialog
onready var player = $Player
onready var transition_rect = $CanvasLayer/TransitionRect

func _ready():
	print("Game Starting")
	player.update_map_limits()

func _input(event):
	if event.is_action_pressed("menu"):
		if menu.visible:
			print("open menu")
			menu.visible = false
			get_tree().paused = false
		else:
			menu.visible = true
			get_tree().paused = true


func _on_WorldManager_new_player_position(data):
	print("in game.gd setting new player position")
	get_node("Player").position.x = data.x
	get_node("Player").position.y = data.y
	# get_node("Player").update_map_limits()


func _on_WorldManager_before_map_change():
	transition_rect.fadeIn()
	get_tree().paused = true


func _on_WorldManager_after_map_change():
	print("AFTER MAP CHANGE")
	transition_rect.fadeOut()
	get_tree().paused = false
	player.update_map_limits()


func _on_Menu_save_game():
	var save_data = {
		"name": PlayerData.player_name,
		"type": PlayerData.char_type,
		"current_location": {
			"map": world_manager.world_name,
			"x": player.position.x,
			"y": player.position.y,
		}
	}
	
	var save_game_name = "savegame-" + PlayerData.player_name + ".save"
	var save_game = File.new()
	if save_game.file_exists("user://" + save_game_name):
		save_game.open("user://" + save_game_name, File.WRITE)
		save_game.store_line(to_json(save_data))
		save_game.close()
	menu.save_game_complete()
