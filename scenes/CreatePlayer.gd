extends Control


onready var char_type_menu = $MarginContainer/VBoxContainer/HBoxContainer/ItemList
onready var name_input = $MarginContainer/VBoxContainer/NameInput/TextEdit
onready var error_box = $MarginContainer/VBoxContainer/ErrorText
onready var transition = $TransitionRect


func _ready():
	transition.fadeOut()
	for item in CharacterData.characters:
		char_type_menu.add_item(" " + item)
		

func create_save_game(user_name, char_type):
	# prep a file object
	print("Starting create save game")
	var save_game = File.new()
	var char_type_info = CharacterData.characters[char_type]
	
	print("Have char type info", char_type_info)
	# check to see if we already have a save with this name
	if save_game.file_exists("user://savegame-" + user_name + ".save"):
		print("save game already exists")
		# we do, so we need to show an error
		error_box.text = "Found existing character with that name"
		
		# and then bail out
		return
	else:
		print("save game does not exist")
		# build our save game string
		var save_game_name = "savegame-" + user_name + ".save"
		
		print("creating save game with name: ", save_game_name)
		# open the new file for saving
		save_game.open("user://" + save_game_name, File.WRITE)
		
		# save the data to the file and close it
		var save_data = {
			"name": user_name,
			"current_location": {
				"map": "World",
				"x": 350,
				"y": 350
			},
			"inventory": [],
			"gold": 10,
			"chests": {},
			"main_character": 0,
			"characters": [
				{
					"type": char_type, 
					"character_name": user_name, 
					"level": 1, 
					"current_hp": char_type_info["max_hp"], 
					"max_hp": char_type_info["max_hp"], 
					"experience": 0,
					"str": char_type_info["str"],
					"dex": char_type_info["dex"],
					"int": char_type_info["int"],
					"profile_image": "assets/characters/" + char_type.to_lower() + ".png"
				}
			],
			"npcs": {}
		}
		save_game.store_line(to_json(save_data))
		save_game.close()
		
		print("Saved game data to file")
		print(save_data)
		# set our global player data with what the user has selected
		PlayerData.player_name = user_name
		print("after player name")
		PlayerData.current_map = save_data["current_location"]["map"]
		print("after current map")
		PlayerData.load_x = save_data["current_location"]["x"]
		print("after map x")
		PlayerData.load_y = save_data["current_location"]["y"]
		print("after map y")
		PlayerData.gold = save_data["gold"]
		print("after gold")
		PlayerData.characters = []
		PlayerData.characters.append_array(save_data["characters"])
		print("Finished setting up player data")
		# change to the game scene
		print("about to run get_tree()")
		var tree = get_tree()
		print(tree)
		var error = tree.change_scene("res://scenes/Game.tscn")
		print(error)


func _on_FinishButton_pressed():
	var player_name = name_input.text
	var player_type = char_type_menu.get_selected_items()
	
	if len(player_type) == 0:
		print("missing info")
		return
	
	if player_name == "":
		print("missing info")
		return
	
	var char_list = CharacterData.characters.keys()
	player_type = char_list[player_type[0]]
	print("About to run create save game")
	create_save_game(player_name, player_type)
	

func _on_BackButton_pressed():
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	var _error = get_tree().change_scene("res://scenes/MainMenu.tscn")
