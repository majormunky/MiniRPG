extends Control


onready var char_type_menu = $MarginContainer/VBoxContainer/HBoxContainer/ItemList
onready var name_input = $MarginContainer/VBoxContainer/NameInput/TextEdit

var char_types = [
	"Warrior",
	"Mage",
	"Thief"
]

func _ready():
	for item in char_types:
		char_type_menu.add_item(" " + item)


func create_save_game(user_name, char_type):
	print("Player Type: ", char_type)
	print("Player Name: ", user_name)
	
	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		print("Found save game")
	else:
		print("Unable to find save game, creating new one")
		save_game.open("user://savegame.save", File.WRITE)
		save_game.store_line("name:" + user_name)
		save_game.store_line("type:" + char_type)
		save_game.close()
		print("Game Saved")


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
	
	
	
