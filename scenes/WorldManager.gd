extends Node2D


var maps = {}
var world = null

func _ready():
	maps["World"] = preload("res://scenes/maps/World.tscn")
	maps["FirstTown"] = preload("res://scenes/maps/FirstTown.tscn")
	world = $World
	world.connect("location_change", self, "on_location_change")


func on_town_entered(name):
	print("TOWN ENTERED", name)
	load_world(name)


func on_location_change(name):
	print("LOCATION CHANGED", name)
	load_world(name)


func load_world(world_name):
	# remove current world
	remove_child(get_node("World"))
	
	# Create new map that was called for
	var new_map = maps[world_name].instance()
	
	# Add map as a child
	add_child(new_map)
	
	new_map.connect("location_change", self, "on_location_change")
