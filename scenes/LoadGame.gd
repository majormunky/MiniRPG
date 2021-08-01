extends Control

onready var save_game_list = $MarginContainer/VBoxContainer/ItemList
var saved_game_file_list = null

func _ready():
	print("Load Game - Ready")
	var saved_games = File.new()
	saved_games.open("user://savedgames.save", File.READ)
	var text = saved_games.get_as_text()
	saved_games.close()
	saved_game_file_list = text.split("\n")
	
	for line in saved_game_file_list:
		save_game_list.add_item(" " + line.split(":")[0])


func _on_LoadGameButton_pressed():
	# This is the game the user selected
	var selected_save = save_game_list.get_selected_items()
	
	# check if user has hit the load button without selecting a game
	if len(selected_save) == 0:
		# if so, we can just bail out
		return
	
	# our selected save is a list of indexes
	# this gets us the real data
	selected_save = saved_game_file_list[selected_save[0]]
	
	# our data is the user name and save game name with a colon between
	var parts = selected_save.split(":")
	
	# prep a new save game 
	var save_file = File.new()
	
	# check to see if we have a file to load
	if save_file.file_exists("user://" + parts[1]):
		# open the file
		save_file.open("user://" + parts[1], File.READ)
		
		# get the data from the file
		var save_text = save_file.get_as_text()
		save_file.close()
		
		# break up our save game into lines
		# var lines = save_text.split("\n")
		var data = parse_json(save_text)
		
		# load data
		PlayerData.player_name = data.name
		PlayerData.char_type = data.type
		
		# load the main game
		get_tree().change_scene("res://scenes/Game.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
