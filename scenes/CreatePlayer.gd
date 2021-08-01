extends Control


onready var char_type_menu = $MarginContainer/VBoxContainer/HBoxContainer/ItemList
onready var name_input = $MarginContainer/VBoxContainer/NameInput/TextEdit
onready var error_box = $MarginContainer/VBoxContainer/ErrorText

var char_types = [
	"Warrior",
	"Mage",
	"Thief"
]

func _ready():
	for item in char_types:
		char_type_menu.add_item(" " + item)


func create_save_game(user_name, char_type):
	# prep a file object
	var save_game = File.new()
	
	# check to see if we already have a save with this name
	if save_game.file_exists("user://savegame-" + user_name + ".save"):
		# we do, so we need to show an error
		error_box.text = "Found existing character with that name"
		
		# and then bail out
		return
	else:
		# build our save game string
		var save_game_name = "savegame-" + user_name + ".save"
		
		# open the new file for saving
		save_game.open("user://" + save_game_name, File.WRITE)
		
		# save the data to the file and close it
		save_game.store_line("name:" + user_name)
		save_game.store_line("type:" + char_type)
		save_game.close()
		
		# we need to register this save game in our text file
		# this file holds a list of our saved games
		# we do this due to difficulties listing all the save games in a folder
		if save_game.file_exists("user://savedgames.save"):
			# if our save game register already exists
			# we need to be sure we set our cursor at the end of the file
			# we also need to open the file as READ_WRITE 
			# so we can seek
			save_game.open("user://savedgames.save", File.READ_WRITE)
			save_game.seek_end()
		else:
			# if this is a new file, we can just open it normally
			save_game.open("user://savedgames.save", File.WRITE)

		# store the save game adn close the file
		save_game.store_line(user_name + ":" + save_game_name)		
		save_game.close()
		
		# set our global player data with what the user has selected
		PlayerData.player_name = user_name
		PlayerData.char_type = char_type
		
		# change to the game scene
		get_tree().change_scene("res://scenes/Game.tscn")


func _on_FinishButton_pressed():
	var player_name = name_input.text
	var player_type = char_type_menu.get_selected_items()
	
	if len(player_type) == 0:
		print("missing info")
		return
	
	if player_name == "":
		print("missing info")
		return
	
	player_type = char_types[player_type[0]]
	create_save_game(player_name, player_type)
	

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
