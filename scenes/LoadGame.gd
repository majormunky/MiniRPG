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
