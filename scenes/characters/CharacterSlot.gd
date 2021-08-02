extends ColorRect

func _ready():
	var character_data = load("res://assets/characters/Warrior.tres")
	
	var profile = get_node("MarginContainer/HBoxContainer/CenterContainer/TextureRect")
	var name = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Name/Data")
	var job = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Job/Data")
	var level = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Level/Data")
	var hp = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/HP/Data")
	var experience = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Exp/Data")
	
	
	profile.texture = character_data.profile_image
	name.text = "TestName"
	job.text = character_data.character_job
	level.text = str(character_data.level)
	hp.text = str(character_data.current_health) + "/" + str(character_data.max_health)
	experience.text = str(character_data.experience)
