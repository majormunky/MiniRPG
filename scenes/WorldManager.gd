extends Node2D


var maps = {}
var world = null
var map_data: Dictionary
var world_name = null

signal before_map_change
signal after_map_change
signal new_player_position(data)
signal chest_opened(data)


func on_chest_opened(data):
	print("in worldmanager - chest opened")
	emit_signal("chest_opened", data)


func load_json_data(filepath):
	var json_data
	var file_data = File.new()
	file_data.open(filepath, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	return json_data.result


func _ready():
	print("WorldManager Ready Starting")
	map_data = load_json_data("res://assets/data/world.json")
	var item_data = load_json_data("res://assets/data/items.json")
	
	for world_key in map_data:
		var map_path = "res://" + map_data[world_key].filepath
		maps[world_key] = load(map_path)
	
	ItemData.items = item_data
	
	load_world(PlayerData.current_map)
	emit_signal("new_player_position", {"x": PlayerData.load_x, "y": PlayerData.load_y})


func calculate_bounds(tilemap):
	var cell_bounds = tilemap.get_used_rect()
	# create transform
	var cell_to_pixel = Transform2D(Vector2(tilemap.cell_size.x * tilemap.scale.x, 0), Vector2(0, tilemap.cell_size.y * tilemap.scale.y), Vector2())
	# apply transform
	return Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size)


func on_town_entered(name):
	print("TOWN ENTERED ", name)
	load_world(name)


func on_location_change(name):
	print("LOCATION CHANGED ", name)
	emit_signal("before_map_change")
	yield(get_tree().create_timer(0.5), "timeout")
	load_world(name)
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("after_map_change")


func on_set_player_position(data):
	print("PLAYER POSITION CHANGE")
	print(data)


func load_world(name):
	print("Loading Map: " + name)
	# remove current world
	var children = get_children()
	if len(children) > 0:
		remove_child(children[0])
	
	# a flag to know if we are loading a fresh new map
	# or if we are coming from a different map
	var last_map = null
	
	# if our world name is null, we are starting fresh
	if world_name == null:
		# we can just set our world name
		world_name = name
	else:
		# otherwise, we hold the last map name
		last_map = world_name
		
		# and then set our new map name
		world_name = name
		
	# Create new map that was called for
	var new_map = maps[name].instance()
	var data = map_data[name]
	
	if last_map:
		# we loaded a previous map
		print("LAST MAP", last_map)
		var new_player_pos = data["teleports"][last_map]["from"]
		emit_signal("new_player_position", new_player_pos)
	
	# Add map as a child
	add_child(new_map)
	
	print("Calculating map size")
	var map_size = calculate_bounds(new_map.get_node("TileMap"))
	MapData.map_height = map_size.size.y
	MapData.map_width = map_size.size.x
	
	new_map.connect("location_change", self, "on_location_change")
	new_map.connect("chest_opened", self, "on_chest_opened")
	# new_map.connect("set_player_position", self, "on_set_player_position")
