extends Node2D

onready var action_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/CommandPanel/VBoxContainer/ActionList
onready var player_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/PlayerListPanel/PlayerList
onready var enemy_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/EnemyList/VBoxContainer
onready var right_arena = $Panel/MarginContainer/VBoxContainer/Arena/RightArena

onready var Slime = preload("res://scenes/enemies/Slime.tscn")
onready var BattleItem = preload("res://scenes/BattleItem.tscn")
var monsters = []


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
	
	load_monsters(GameData.battle_data["extra"])

func load_monsters(monster_list):
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var test_monster = monster_list[0]
	var monster_count = rng.randi_range(
		test_monster["spawn_count"]["min"],
		test_monster["spawn_count"]["max"]
	)

	for i in range(monster_count):
		var new_slime = Slime.instance()
		monsters.append(new_slime)
		
		right_arena.add_child(new_slime)
		new_slime.position.y = i * 50
		
		var new_battle_item = BattleItem.instance()

		enemy_list.add_child(new_battle_item)
		new_battle_item.setup({"monster_name": "Slime"})
