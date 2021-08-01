extends Node2D


var maps = {}
var world = null
var map_data: Dictionary


func load_json_data(filepath):
	var json_data
	var file_data = File.new()
	file_data.open(filepath, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	return json_data.result


func _ready():
	map_data = load_json_data("res://assets/data/world.json")
	
	for world_key in map_data:
		var map_path = "res://" + map_data[world_key].filepath
		maps[world_key] = load(map_path)
	load_world("World")


func on_town_entered(name):
	print("TOWN ENTERED", name)
	load_world(name)


func on_location_change(name):
	print("LOCATION CHANGED", name)
	load_world(name)


func load_world(world_name):
	# remove current world
	var children = get_children()
	if len(children) > 0:
		remove_child(children[0])
	
	# Create new map that was called for
	var new_map = maps[world_name].instance()
	
	# Add map as a child
	add_child(new_map)
	
	new_map.connect("location_change", self, "on_location_change")
