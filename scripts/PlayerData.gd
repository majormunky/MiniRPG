extends Node

var player_name = "test"
var current_map = "World"
var load_x = null
var load_y = null
var inventory = []
var max_hp = 0
var current_hp = 0
var gold = 0
var characters = []
var main_character = 0


func equip_item(character_name, slot, item_name):
	for character in characters:
		if character["character_name"] == character_name:
			character["equipment"][slot.to_lower()] = item_name


func remove_item_from_inventory(item_name):
	for item in inventory:
		if item["item_name"] == item_name:
			if item["stack_size"] == 1:
				# we can just remove it
				inventory.erase(item)
			else:
				# we have to check quantity
				if item["quantity"] > 1:
					# we have more than one of these, just decrement its quantity
					item["quantity"] -= 1
				else:
					# this is our last item, we can just remove it from our inventory
					inventory.erase(item)
