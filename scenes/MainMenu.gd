extends Control

onready var new_game_scene = preload("res://scenes/CreatePlayer.tscn")
onready var transition = $TransitionRect


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
		MonsterData.monsters[monster_key] = monster_data[monster_key]

	transition.fadeOut()


func _on_New_Game_pressed():
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	var _error = get_tree().change_scene("res://scenes/CreatePlayer.tscn")


func _on_Load_Game_pressed():
	print("Changing scenes")
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	var _error = get_tree().change_scene("res://scenes/LoadGame.tscn")
