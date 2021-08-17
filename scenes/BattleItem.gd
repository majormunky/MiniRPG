extends Control

onready var monster_name_label = $HBoxContainer/MonsterName
onready var health_bar = $HBoxContainer/HealthBar

var monster_name = null
var current_health = null
var max_health = null


func setup(mon_name, data):
	print(data)
	monster_name = mon_name
	current_health = data["max_hp"]
	max_health = data["max_hp"]
	health_bar.max_value = max_health
	health_bar.value = current_health
	monster_name_label.text = monster_name


func health_changed(new_value):
	current_health = new_value
	health_bar.value = current_health
