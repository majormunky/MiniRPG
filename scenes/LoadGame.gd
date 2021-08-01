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
	# load saved game
	var selected_save = save_game_list.get_selected_items()
	if len(selected_save) == 0:
		return
	
	selected_save = saved_game_file_list[selected_save[0]]
	var parts = selected_save.split(":")
	
	var save_file = File.new()
	print(parts[1])
	if save_file.file_exists("user://" + parts[1]):
		save_file.open("user://" + parts[1], File.READ)
		var save_text = save_file.get_as_text()
		save_file.close()
		var lines = save_text.split("\n")
		
		for line in lines:
			var line_parts = line.split(":")
			if line_parts[0] == "name":
				PlayerData.player_name = line_parts[1]
			elif line_parts[0] == "type":
				PlayerData.char_type = line_parts[1]
		
		get_tree().change_scene("res://scenes/Game.tscn")
