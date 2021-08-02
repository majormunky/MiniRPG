extends Control


onready var char_type_menu = $MarginContainer/VBoxContainer/HBoxContainer/ItemList
onready var name_input = $MarginContainer/VBoxContainer/NameInput/TextEdit
onready var error_box = $MarginContainer/VBoxContainer/ErrorText
onready var transition = $TransitionRect

var char_types = [
	"Warrior",
	"Mage",
	"Thief"
]

func _ready():
	transition.fadeOut()
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
		var save_data = {
			"name": user_name,
			"type": char_type,
			"current_location": {
				"map": "World",
				"x": 350,
				"y": 350
			},
			"inventory": [],
			"gold": 10,
			"current_hp": 20,
			"max_hp": 20,
			"chests": {}
		}
		save_game.store_line(to_json(save_data))
		save_game.close()

		# set our global player data with what the user has selected
		PlayerData.player_name = user_name
		PlayerData.char_type = char_type
		PlayerData.current_map = save_data["current_location"]["map"]
		PlayerData.load_x = save_data["current_location"]["x"]
		PlayerData.load_y = save_data["current_location"]["y"]
		PlayerData.gold = save_data["gold"]
		PlayerData.current_hp = save_data["current_hp"]
		PlayerData.max_hp = save_data["max_hp"]
		
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
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://scenes/MainMenu.tscn")
