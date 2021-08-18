extends Node2D

onready var action_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/CommandPanel/VBoxContainer/ActionList
onready var player_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/PlayerListPanel/MarginContainer/PlayerList
onready var enemy_list = $Panel/MarginContainer/VBoxContainer/BattleInfo/EnemyList/MarginContainer/VBoxContainer
onready var right_arena = $Panel/MarginContainer/VBoxContainer/Arena/RightArena
onready var battle_over_panel = $BattleOverPanel

onready var PlayerBattleItem = preload("res://scenes/battle/PlayerBattleItem.tscn")
onready var Slime = preload("res://scenes/enemies/Slime.tscn")
onready var BattleItem = preload("res://scenes/BattleItem.tscn")
var monsters = []
var battle_items = []
var current_turn = null

var player_actions = [
	"Fight",
	"Items",
	"Magic",
	"Flee"
]
var character_data = {}

func _ready():
	for action in player_actions:
		action_list.add_item(" " + action)

	for character in PlayerData.characters:
		var char_name = character["character_name"]
		character_data[char_name] = character
	
	var character_names = character_data.keys()

	current_turn = character_names.front()
	
	for cname in character_names:
		# player_list.add_item(" " + cname)
		var player_item = PlayerBattleItem.instance()
		player_list.add_child(player_item)
		# print(character_data[cname])
		player_item.setup(character_data[cname])
	
	load_monsters()
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


func load_monsters():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var monster_list = GameData.battle_data["extra"]
	
	var test_monster = monster_list[0]
	var monster_name = test_monster["name"]
	var monster_data = MonsterData.monsters[monster_name]
	var monster_count = rng.randi_range(
		test_monster["spawn_count"]["min"],
		test_monster["spawn_count"]["max"]
	)

	for i in range(monster_count):
		
		var new_monster = Slime.instance()
		monsters.append(new_monster)
		new_monster.health = monster_data["max_hp"]
		new_monster.monster_id = i
		
		new_monster.connect("monster_died", self, "on_monster_died")
		new_monster.connect("monster_health_changed", self, "on_monster_health_changed")
		
		right_arena.add_child(new_monster)
		new_monster.position.y = i * 50
		
		var new_battle_item = BattleItem.instance()

		enemy_list.add_child(new_battle_item)
		new_battle_item.setup(monster_name, monster_data)
		battle_items.append(new_battle_item)


func on_action_flee():
	get_tree().change_scene("res://scenes/Game.tscn")


func on_action_fight():
	print("Fight!")
	# for now lets just grab the first monster in our list
	var target_monster = monsters.front()
	if target_monster:
		var current_char_data = character_data[current_turn]
		# we need to use the current char data to calculate damage
		var dmg = 6
		target_monster.take_damage(dmg)
	else:
		print("Unable to find monster")
		print(monsters)
		print(monsters.front())
		print(monsters[0])
	

func on_action_items():
	print("Items!")


func on_action_magic():
	print("Magic!")

 
func _on_ActionButton_pressed():
	var selected_action = action_list.get_selected_items()
	if selected_action:
		selected_action = player_actions[selected_action[0]]
	else:
		return
	
	if selected_action == "Flee":
		on_action_flee()
	elif selected_action == "Fight":
		on_action_fight()
	elif selected_action == "Magic":
		on_action_magic()
	elif selected_action == "Items":
		on_action_items()

	select_next_character()


func select_next_character():
	var character_names = character_data.keys()
	var current_index = character_names.find(current_turn)
	current_index += 1
	if current_index >= len(character_names):
		current_index = 0
	current_turn = character_names[current_index]
	update_highlight()


func update_highlight():
	var slot1 = get_node("Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot1")
	var slot2 = get_node("Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot2")
	var slot3 = get_node("Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot3")
	var slot4 = get_node("Panel/MarginContainer/VBoxContainer/Arena/LeftArena/GridContainer/Slot4")
	
	slot1.get_node("HighlightTexture").visible = false
	slot2.get_node("HighlightTexture").visible = false
	slot3.get_node("HighlightTexture").visible = false
	slot4.get_node("HighlightTexture").visible = false
	
	var character_names = character_data.keys()
	var current_index = character_names.find(current_turn)
	if current_index == 0:
		slot1.get_node("HighlightTexture").visible = true
	elif current_index == 1:
		slot2.get_node("HighlightTexture").visible = true
	elif current_index == 2:
		slot3.get_node("HighlightTexture").visible = true
	elif current_index == 3:
		slot4.get_node("HighlightTexture").visible = true


func on_monster_died(monster_id):
	print("monster died!", monster_id)
	battle_items[monster_id].visible = false
	
	for monster in monsters:
		if monster.monster_id == monster_id:
			monsters.erase(monster)
	
	if len(monsters) == 0:
		battle_over_panel.popup()


func on_monster_health_changed(monster_id, new_amount):
	battle_items[monster_id].health_changed(new_amount)
	print("monster " + str(monster_id) + " health: ", new_amount)


func _on_BackToGameButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")
