extends Control

onready var new_game_scene = preload("res://scenes/CreatePlayer.tscn")
onready var transition = $TransitionRect

func _ready():
	transition.fadeOut()


func _on_New_Game_pressed():
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://scenes/CreatePlayer.tscn")


func _on_Load_Game_pressed():
	print("Changing scenes")
	transition.fadeIn()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://scenes/LoadGame.tscn")
