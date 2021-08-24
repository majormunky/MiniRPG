extends Node2D

onready var world_manager = $WorldManager
onready var dialog = $CanvasLayer/Dialog
onready var menu = $CanvasLayer/Menu
onready var player = $Player
onready var transition_rect = $CanvasLayer/TransitionRect
onready var area_label = $CanvasLayer/AreaLabelPanel

var remove_npc = false

func _ready():
	print("Game Starting")
	player.update_map_limits()
	transition_rect.visible = true
	dialog.connect("question_response", self, "on_question_response")
	if GameData.player_position_before_battle:
		# if this is set, it means we went into battle and have a position
		# ready to go back to when we are done with the battle
		print("Found position for player")
		player.position = GameData.player_position_before_battle
		player.position.y += 32
		GameData.player_position_before_battle = null
	show_area_label(PlayerData.current_map)


func show_area_label(map_name):
	area_label.get_node("Label").text = map_name
	area_label.visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	area_label.visible = false


func _input(event):
	if event.is_action_pressed("menu"):
		if menu.visible:
			print("close menu")
			menu.close_menu()
			get_tree().paused = false
		else:
			menu.visible = true
			menu._on_ItemList_item_selected(0)
			get_tree().paused = true


func _on_WorldManager_new_player_position(data):
	print("in game.gd setting new player position")
	get_node("Player").position.x = data.x
	get_node("Player").position.y = data.y
	# get_node("Player").update_map_limits()


func _on_WorldManager_before_map_change(map_name):
	PlayerData.current_map = map_name
	transition_rect.fadeIn()
	get_tree().paused = true


func _on_WorldManager_after_map_change(map_name):
	print("AFTER MAP CHANGE -> ", map_name)
	transition_rect.fadeOut()
	get_tree().paused = false
	player.update_map_limits()
	show_area_label(map_name)


func _on_Menu_save_game():
	var save_data = {
		"name": PlayerData.player_name,
		"gold": PlayerData.gold,
		"current_location": {
			"map": world_manager.world_name,
			"x": player.position.x,
			"y": player.position.y,
		},
		"chests": {},
		"inventory": [],
		"characters": PlayerData.characters,
		"npcs": {}
	}
	
	# hold info about what chests have been opened
	for chest_key in GameData.chests:
		save_data["chests"][chest_key] = GameData.chests[chest_key]
	
	for npc_key in GameData.npcs:
		save_data["npcs"][npc_key] = GameData.npcs[npc_key]
	
	save_data["inventory"].append_array(PlayerData.inventory)
	
	var save_game_name = "savegame-" + PlayerData.player_name + ".save"
	var save_game = File.new()
	if save_game.file_exists("user://" + save_game_name):
		save_game.open("user://" + save_game_name, File.WRITE)
		save_game.store_line(to_json(save_data))
		save_game.close()
	menu.save_game_complete()


func _on_WorldManager_chest_opened(data):
	print("Game - Chest opened")
	
	# mark that we have opened this chest
	GameData.chests[data["chest_id"]] = true
	
	# give the player the item in the chest
	player.add_item(data)

	# create a dialog with a message about the item we got
	dialog.open_dialog([
		{"text": "You received a " + data["item"][0]["item"], "select": false}
	])


func _on_Menu_use_inventory_item(item):
	print("Using inventory item:")
	if item.category == "Consumable":
		if item.consumable_type == "health":
			PlayerData.current_hp += item.add_health
			if PlayerData.current_hp > PlayerData.max_hp:
				PlayerData.current_hp = PlayerData.max_hp


func _on_Player_player_inspected():
	print("on_Player_player_inspected")
#	if dialog.visible:
#		dialog.close_dialog()
#		GameData.dialog_open = false
	#if dialog.visible and dialog.keep_open == false:
	#	dialog.close_dialog()


func get_npc_info(id: int):
	for npc in MapData.data[PlayerData.current_map]["npcs"]:
		if npc["id"] == id:
			print("found npc")
			return npc
	return null


func on_question_response(answer):
	print("Answer: ", answer)
	var npc_data = get_npc_info(answer["npc"])
	if npc_data:
		if answer["action"] == "join_party":
			var char_type = npc_data["party_data"]["job"]
			var char_data = GameData.character_data[char_type]
			PlayerData.characters.append({
				"type": char_type, 
				"character_name": npc_data["name"], 
				"level": npc_data["party_data"]["level"], 
				"current_hp": npc_data["party_data"]["current_hp"], 
				"max_hp": npc_data["party_data"]["max_hp"], 
				"experience": 0,
				"profile_image": "assets/characters/" + char_type.to_lower() + ".png",
				"dex": char_data["dex"],
				"str": char_data["str"],
				"int": char_data["int"],
				"equipment": {
					"helmet": null,
					"chest": null,
					"arms": null,
					"legs": null,
					"boots": null,
					"main_hand": null,
					"off_hand": null,
				}
			})
			GameData.npcs[answer["npc"]] = {"state": "joined-party"}
			remove_npc = true


func _on_WorldManager_npc_dialog(lines, npc_id):
	print("Game -> on_WorldManager_npc_dialog")
	print("NPC ID: ", npc_id)
	if dialog.visible:
		dialog.next()
		if remove_npc:
			remove_npc = false
			world_manager.remove_npc(npc_id)
	else:
		dialog.open_dialog(lines, npc_id)


func _on_WorldManager_chest_already_opened():
	dialog.close_dialog()


func _on_WorldManager_enemy_spawn(data):
	# print("enemy spawned", data)
	# print("Enemy Data from Map", MapData.data["World"].monsters)
	# save the current user location on the map so we can go back to it after the battle
	GameData.player_position_before_battle = player.position
	
	# a bunch of nonsense i need to clean up
	var ground_type = data["ground_type"]

	var monster_name = MapData.data["World"].monsters[ground_type][0]["name"]
	var monster_data = GameData.monster_data[monster_name]
	
	data["monster_info"] = monster_data
	data["extra"] = MapData.data["World"].monsters[data["ground_type"]]
	GameData.battle_data = data
	var _error = get_tree().change_scene("res://scenes/BattleScene.tscn")
