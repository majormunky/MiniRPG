extends Control

onready var name_label = $HBoxContainer/NameLabel
onready var health_bar = $HBoxContainer/HealthBar

var character_name = null
var current_health = null
var max_health = null

func setup(data):
	character_name = data["character_name"]
	name_label.text = character_name
	
	health_bar.max_value = data["max_hp"]
	health_bar.value = data["current_hp"]
