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
