extends Node
class_name Character

var character_name: String
var current_hp: int
var max_hp: int
var level: int
var dexterity: int
var strength: int
var intelligence: int
var experience: int
var type: String
var profile_image: String
var profile_offset = {"x": null, "y": null}


var equipment = {
	"arms": null,
	"boots": null,
	"chest": null,
	"helmet": null,
	"legs": null,
	"main_hand": null,
	"off_hand": null
}

func _init(data):
	character_name = data["character_name"]
	current_hp = data["current_hp"]
	max_hp = data["max_hp"]
	level = data["level"]
	dexterity = data["dex"]
	strength = data["str"]
	intelligence = data["int"]
	experience = data["experience"]
	type = data["type"]
	profile_image = data["profile_image"]
	setup()


func setup():
	var char_data = GameData.character_data[type]
	profile_offset["x"] = char_data["map_image_offset"]["x"]
	profile_offset["y"] = char_data["map_image_offset"]["y"]


func get_hp_display():
	return str(current_hp) + "/" + str(max_hp)


func calculate_attack():
	var atk_value = 0
	print("Calculating Attack")
	var item_data = null
	if equipment["main_hand"]:
		item_data = GameData.item_data[equipment["main_hand"]]
		atk_value += int(item_data["attack"])
	if equipment["off_hand"]:
		item_data = GameData.item_data[equipment["off_hand"]]
		atk_value += int(item_data["attack"])
	return str(int(strength * 1.25) + atk_value)


func calculate_defense():
	var def_value = 0
	print("Calculating Defense")
	if equipment["helmet"]:
		var item_data = GameData.item_data[equipment["helmet"]]
		def_value += item_data["defense"]
	if equipment["chest"]:
		var item_data = GameData.item_data[equipment["chest"]]
		def_value += item_data["defense"]
	if equipment["arms"]:
		var item_data = GameData.item_data[equipment["arms"]]
		def_value += item_data["defense"]
	if equipment["legs"]:
		var item_data = GameData.item_data[equipment["legs"]]
		def_value += item_data["defense"]
	if equipment["boots"]:
		var item_data = GameData.item_data[equipment["boots"]]
		def_value += item_data["defense"]
	
	return str(int(dexterity * 0.5 + strength * 0.5) + def_value)


func calculate_speed():
	var speed_value = 0
	print("Calculating Speed")
	speed_value += int(dexterity)
	return str(speed_value)


func get_equipment_slot_name(slot_name):
	if equipment[slot_name]:
		return equipment[slot_name]
	else:
		return "None"

