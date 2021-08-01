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
	var save_game = File.new()
	if save_game.file_exists("user://savegame-" + user_name + ".save"):
		error_box.text = "Found existing character with that name"
	else:
		print("Unable to find save game, creating new one")
		var save_game_name = "savegame-" + user_name + ".save"
		save_game.open("user://" + save_game_name, File.WRITE)
		save_game.store_line("name:" + user_name)
		save_game.store_line("type:" + char_type)
		save_game.close()
		
		if save_game.file_exists("user://savedgames.save"):
			save_game.open("user://savedgames.save", File.READ_WRITE)
			save_game.seek_end()
		else:
			save_game.open("user://savedgames.save", File.WRITE)

		save_game.store_line(user_name + ":" + save_game_name)		
		save_game.close()
		
		PlayerData.player_name = user_name
		PlayerData.char_type = char_type
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
	
	
	
