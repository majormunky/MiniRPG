extends Control

onready var save_game_list = $MarginContainer/VBoxContainer/ItemList
onready var transition = $TransitionRect
var saved_game_file_list = null

func _ready():
	print("Load Game - Ready")
	transition.fadeOut()
	
	saved_game_file_list = get_save_game_list()
	
	for line in saved_game_file_list:
		var line_parts = line.split("-")
		var save_game_name = line_parts[1].split(".")[0]
		save_game_list.add_item(" " + save_game_name)


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
	
	# prep a new save game 
	var save_file = File.new()
	
	# check to see if we have a file to load
	if save_file.file_exists("user://" + selected_save):
		# open the file
		save_file.open("user://" + selected_save, File.READ)
		
		# get the data from the file
		var save_text = save_file.get_as_text()
		save_file.close()
		
		# break up our save game into lines
		# var lines = save_text.split("\n")
		var data = parse_json(save_text)
		
		# load data
		PlayerData.player_name = data.name
		PlayerData.char_type = data.type
		
		# figure out what map to load
		PlayerData.current_map = data.current_location.map
		PlayerData.load_x = data.current_location.x
		PlayerData.load_y = data.current_location.y
		
		# load inventory
		PlayerData.inventory.append_array(data.inventory)
		
		# load up game state
		GameData.chests = data.chests
		
		# load the main game
		get_tree().change_scene("res://scenes/Game.tscn")


func _on_BackButton_pressed():
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_DeleteSaveButton_pressed():
	var selected_save = save_game_list.get_selected_items()
	var selected_save_index = null
	
	# check if user has hit the load button without selecting a game
	if len(selected_save) == 0:
		# if so, we can just bail out
		return
	
	# our selected save is a list of indexes
	# this gets us the real data
	selected_save_index = selected_save[0]
	selected_save = saved_game_file_list[selected_save_index]
	
	
	var save_file = File.new()
	var save_path = "user://" + selected_save
	if save_file.file_exists(save_path):
		var dir = Directory.new()
		dir.open("user://")
		dir.remove(save_path)
		save_game_list.remove_item(selected_save_index)


func get_save_game_list():
	var path = "user://"
	var dir = Directory.new()
	var result = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.begins_with("savegame-"):
				result.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return result
		
		
