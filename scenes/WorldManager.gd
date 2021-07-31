extends Node2D


var maps = {}

func _ready():
	maps["World"] = preload("res://scenes/maps/World.tscn")
	maps["FirstTown"] = preload("res://scenes/maps/FirstTown.tscn")

func load_world(world_name):
	# remove current world
	remove_child(get_node("World"))
	
	# Create new map that was called for
	var new_map = maps[world_name].instance()
	
	# Add map as a child
	add_child(new_map)
