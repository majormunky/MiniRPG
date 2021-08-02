extends StaticBody2D


var dialog_text = []
var id

signal npc_starts_talking(lines)


func setup(data):
	print("in npc")
	print(data)
	position.x = data["position"]["x"]
	position.y = data["position"]["y"]
	dialog_text.append_array(data["dialog"])
	get_node("Sprite").texture = load("res://" + data["map_image"])


func inspect():
	print("npc getting inspected")
	emit_signal("npc_starts_talking", dialog_text)


func _on_InspectBox_area_entered(_area):
	inspect()
