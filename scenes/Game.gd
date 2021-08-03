extends Node2D

onready var world_manager = $WorldManager
onready var menu = $CanvasLayer/Menu
onready var dialog = $CanvasLayer/Dialog
onready var player = $Player
onready var transition_rect = $CanvasLayer/TransitionRect


func _ready():
	print("Game Starting")
	player.update_map_limits()
	transition_rect.visible = true
	# world_manager.connect()


func _input(event):
	if event.is_action_pressed("menu"):
		if menu.visible:
			print("close menu")
			menu.visible = false
			menu._on_ItemList_item_selected(0)
			get_tree().paused = false
		else:
			menu.visible = true
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
		"characters": PlayerData.characters
	}
	
	# hold info about what chests have been opened
	for chest_key in GameData.chests:
		save_data["chests"][chest_key] = GameData.chests[chest_key]
	
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
		{"text": "You received a " + data["item"][0]["item"]}
	])


func _on_Menu_use_inventory_item(item):
	print("Using inventory item:")
	if item.category == "Consumable":
		if item.consumable_type == "health":
			PlayerData.current_hp += item.add_health
			if PlayerData.current_hp > PlayerData.max_hp:
				PlayerData.current_hp = PlayerData.max_hp


func _on_Player_player_inspected():
	if dialog.visible and dialog.keep_open == false:
		dialog.close_dialog()


func _on_WorldManager_npc_dialog(lines):
	print("npc dialog")
	print(lines)
	if dialog.visible:
		dialog.next()
	else:
		dialog.open_dialog(lines)

