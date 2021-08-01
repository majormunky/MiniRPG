extends Control


onready var char_type_menu = $MarginContainer/VBoxContainer/HBoxContainer/ItemList
onready var name_input = $MarginContainer/VBoxContainer/NameInput/TextEdit

var char_types = [
	"Warrior",
	"Mage",
	"Thief"
]

func _ready():
	for item in char_types:
		char_type_menu.add_item(" " + item)


func _on_FinishButton_pressed():
	var player_name = name_input.text
	var player_type = char_type_menu.get_selected_items()
	
	if len(player_type) == 0:
		print("missing info")
		return
	
	if player_name == "":
		print("missing info")
		return
	
	player_type = char_types[player_type[0]]
	
	print("Player Type: ", player_type)
	print("Player Name: ", player_name)
