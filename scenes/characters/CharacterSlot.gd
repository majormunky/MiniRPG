extends ColorRect

func update_data(character_data):
	var profile = get_node("MarginContainer/HBoxContainer/CenterContainer/TextureRect")
	var name = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Name/Data")
	var job = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Job/Data")
	var level = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Level/Data")
	var hp = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/HP/Data")
	var experience = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Exp/Data")
	
	profile.texture = load("res://" + character_data.profile_image)
	name.text = character_data.character_name
	job.text = character_data.character_job
	level.text = str(character_data.level)
	hp.text = str(character_data.current_health) + "/" + str(character_data.max_health)
	experience.text = str(character_data.experience)
