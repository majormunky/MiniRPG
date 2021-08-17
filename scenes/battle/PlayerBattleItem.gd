extends Control

var character_name = null
var current_health = null
var max_health = null

func setup(data):
	character_name = data["character_name"]
	get_node("HBoxContainer/NameLabel").text = character_name
