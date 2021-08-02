extends StaticBody2D


var dialog_text = ["Hello, my name is Bob", "Have you visited my village yet?"]

signal npc_starts_talking(lines)

func inspect():
	print("npc getting inspected")
	emit_signal("npc_starts_talking", dialog_text)


func _on_InspectBox_area_entered(_area):
	inspect()
