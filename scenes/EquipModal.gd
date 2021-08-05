extends Popup


onready var item_list = $VBoxContainer/ItemList


func setup(item_type):
	print("Item Type: ", item_type)
	
	var test_items = [
		"Item 1",
		"Item 2",
		"Item 3"
	]
	
	item_list.clear()
	
	for item in test_items:
		item_list.add_item(item)


func _on_CloseButton_pressed():
	visible = false


func _on_EquipButton_pressed():
	pass # Replace with function body.
