extends Control

onready var monster_name_label = $MonsterName
var monster_name = null
var current_health = null
var max_health = null

func setup(mon_name, data):
	print(data)
	monster_name = mon_name
	current_health = data["max_hp"]
	max_health = data["max_hp"]
	update_label()


func health_changed(new_value):
	current_health = new_value
	update_label()


func update_label():
	monster_name_label.text = monster_name + " - " + str(current_health) + "/" + str(max_health)
