extends Control

onready var new_game_scene = preload("res://scenes/CreatePlayer.tscn")

func _ready():
	pass


func _on_New_Game_pressed():
	get_tree().change_scene("res://scenes/CreatePlayer.tscn")


func _on_Load_Game_pressed():
	print("Changing scenes")
	get_tree().change_scene("res://scenes/LoadGame.tscn")
