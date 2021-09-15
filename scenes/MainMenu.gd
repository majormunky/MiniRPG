extends Control

onready var new_game_scene = preload("res://scenes/CreatePlayer.tscn")
onready var transition = $TransitionRect
onready var menu_obj = $MarginContainer/VBoxContainer/MarginContainer2/MenuOptions

var current_option = 0


func load_json_data(filepath):
	var json_data
	var file_data = File.new()
	file_data.open(filepath, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	return json_data.result


func _ready():
	print("Main Menu Ready")
	var character_data = load_json_data("res://assets/data/characters.json")
	for char_key in character_data:
		GameData.character_data[char_key] = character_data[char_key]
	
	var monster_data = load_json_data("res://assets/data/monsters.json")
	for monster_key in monster_data:
		GameData.monster_data[monster_key] = monster_data[monster_key]

	transition.fadeOut()


func _input(event):
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		if current_option == 0:
			current_option = 1
		else:
			current_option = 0
		update_menu()
	elif event.is_action_pressed("ui_accept"):
		if current_option == 0:
			_on_New_Game_pressed()
		else:
			_on_Load_Game_pressed()


func update_menu():
	if current_option == 0:
		menu_obj.get_node("NewGameLabel/ColorRect").visible = true
		menu_obj.get_node("LoadGameLabel/ColorRect").visible = false
	else:
		menu_obj.get_node("NewGameLabel/ColorRect").visible = false
		menu_obj.get_node("LoadGameLabel/ColorRect").visible = true


func _on_New_Game_pressed():
	transition.visible = true
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	var _error = get_tree().change_scene("res://scenes/CreatePlayer.tscn")


func _on_Load_Game_pressed():
	transition.visible = true
	print("Changing scenes")
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	var _error = get_tree().change_scene("res://scenes/LoadGame.tscn")
