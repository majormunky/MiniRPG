extends StaticBody2D


func inspect():
	print("npc getting inspected")


func _on_InspectBox_area_entered(_area):
	inspect()
