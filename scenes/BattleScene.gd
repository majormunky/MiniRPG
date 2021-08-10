extends Node2D

onready var action_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/CommandPanel/ActionList
onready var player_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/PlayerListPanel/PlayerList

func _ready():
	var test_actions = [
		"Fight",
		"Items",
		"Magic",
		"Flee"
	]
	
	for action in test_actions:
		action_list.add_item(" " + action)
	
	var character_data = {}
	for character in PlayerData.characters:
		var char_name = character["character_name"]
		character_data[char_name] = character
	
	var character_names = character_data.keys()
	
	for cname in character_names:
		player_list.add_item(" " + cname)

	print("Battle Data", GameData.battle_data)

