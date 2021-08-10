extends Control

onready var monster_name_label = $MonsterName
var monster_name = null

func setup(data):
	monster_name = data["monster_name"]
	monster_name_label.text = monster_name
