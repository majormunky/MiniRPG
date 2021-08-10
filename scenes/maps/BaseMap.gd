extends Node2D
class_name BaseMap

signal location_change(name)
signal chest_opened(data)
signal npc_dialog(lines, npc_id)
signal chest_already_opened
signal enemy_spawn(data)

onready var Chest = preload("res://scenes/items/Chest.tscn")
onready var NPC = preload("res://scenes/characters/NPC.tscn")

func _ready():
	var chest_list = MapData.data[PlayerData.current_map].chests
	var npc_list = MapData.data[PlayerData.current_map].npcs
	var enemy_list = MapData.data[PlayerData.current_map].monsters
	var chest_container = get_node("chests")
	var npc_container = get_node("npcs")
	
	# remove any existing chests
	for child in chest_container.get_children():
		child.queue_free()
	
	# load in all of our chests
	for chest in chest_list:
		if GameData.chests.has(str(chest.id)):
			add_chest(chest, chest.id, true)
		else:
			add_chest(chest, chest.id, false)
	
	for child in npc_container.get_children():
		child.queue_free()
	
	# load npcs
	print("Loading NPCs")
	for npc in npc_list:
		# if an npc has joined our party
		# then we don't want to load that npc when we load the game
		# TODO: This may change if we decide to leave the npc?
		if GameData.npcs.has(str(npc.id)):
			# check to see if the state of the npc is joined party
			# if so, we want to skip over this npc
			if GameData.npcs[str(npc.id)].state == "joined-party":
				continue
		
		var new_npc = NPC.instance()
		npc_container.add_child(new_npc)
		new_npc.setup(npc)
		new_npc.connect("npc_starts_talking", self, "on_npc_start_talking")
	print("Finished loading npcs")
	
	print("Loading enemies")
	MapData.data["World"].monsters = enemy_list


func on_npc_start_talking(lines, npc_id):
	emit_signal("npc_dialog", lines, npc_id)


func add_chest(item, chest_id, is_opened):
	var chest = Chest.instance()
	chest.position.x = item.position["x"]
	chest.position.y = item.position["y"]
	if is_opened:
		# if our chest has been opened already
		# we just need to re-open it
		chest.open()
	else:
		# if our chest hasn't been opened
		# we need to add our item to it
		# and setup a listener for when it does get opened
		chest.items.append(item)
		chest.connect("chest_opened", self, "on_chest_opened")
		chest.connect("chest_already_opened", self, "on_chest_already_opened")
	chest.id = chest_id
	get_node("chests").add_child(chest)


func on_chest_already_opened():
	emit_signal("chest_already_opened")


func on_chest_opened(data):
	print("In World - Chest Opened")
	emit_signal("chest_opened", data)
