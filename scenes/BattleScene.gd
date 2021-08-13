extends Node2D

onready var action_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/CommandPanel/VBoxContainer/ActionList
onready var player_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/PlayerListPanel/PlayerList
onready var enemy_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/EnemyList/VBoxContainer
onready var right_arena = $Panel/MarginContainer/VBoxContainer/Arena/RightArena

onready var Slime = preload("res://scenes/enemies/Slime.tscn")
onready var BattleItem = preload("res://scenes/BattleItem.tscn")
var monsters = []
var player_actions = [
	"Fight",
	"Items",
	"Magic",
	"Flee"
]

func _ready():
	
	
	for action in player_actions:
		action_list.add_item(" " + action)
	
	var character_data = {}
	for character in PlayerData.characters:
		var char_name = character["character_name"]
		character_data[char_name] = character
	
	var character_names = character_data.keys()
	
	for cname in character_names:
		player_list.add_item(" " + cname)
	
	load_monsters(GameData.battle_data["extra"])
	load_characters()


func load_characters():
	var slot1 = $Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot1
	var char1 = PlayerData.characters[0]
	slot1.get_node("TextureRect").texture = load("res://" + char1.profile_image)
	slot1.get_node("HighlightTexture").visible = true
	
	if len(PlayerData.characters) > 1:
		var slot2 = $Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot2
		var char2 = PlayerData.characters[1]
		slot2.get_node("TextureRect").texture = load("res://" + char2.profile_image)
	
	if len(PlayerData.characters) > 2:
		var slot3 = $Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot3
		var char3 = PlayerData.characters[2]
		slot3.get_node("TextureRect").texture = load("res://" + char3.profile_image)
	
	if len(PlayerData.characters) > 3:
		var slot4 = $Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot4
		var char4 = PlayerData.characters[3]
		slot4.get_node("TextureRect").texture = load("res://" + char4.profile_image)

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


func on_action_flee():
	get_tree().change_scene("res://scenes/Game.tscn")

 
func _on_ActionButton_pressed():
	var selected_action = action_list.get_selected_items()
	if selected_action:
		selected_action = player_actions[selected_action[0]]
	else:
		return
	
	if selected_action == "Flee":
		on_action_flee()

