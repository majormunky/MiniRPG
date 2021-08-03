extends ColorRect

var data

signal info_button_clicked(character_data)

func update_data(character_data):
	var profile = get_node("MarginContainer/HBoxContainer/CenterContainer/TextureRect")
	var name = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Name/Data")
	var job = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Job/Data")
	var level = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Level/Data")
	var hp = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/HP/Data")
	var experience = get_node("MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Exp/Data")

	profile.texture = load("res://" + character_data.profile_image)
	name.text = character_data.character_name
	job.text = character_data.type
	level.text = str(character_data.level)
	hp.text = str(character_data.current_hp) + "/" + str(character_data.max_hp)
	experience.text = str(character_data.experience)
	
	data = character_data


func _gui_input(event):
	if event is InputEventMouseButton:
		print(event)
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("I've been clicked D:")



func _on_InfoButton_pressed():
	pass # Replace with function body.
	emit_signal("info_button_clicked", data)
