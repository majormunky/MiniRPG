extends Popup


onready var item_list = $VBoxContainer/ItemList
var slot_name = null

signal character_equipped_item(item_name, slot_name)

func setup(item_type):
	print("Item Type: ", item_type)
	slot_name = item_type
	var matching_items = []
	
	for item in PlayerData.inventory:
		if item["slot"] == item_type.to_lower():
			matching_items.append(item)
	print("Found ", str(len(matching_items)), " items")
	item_list.clear()
	
	for item in matching_items:
		item_list.add_item(item["item_name"])


func _on_CloseButton_pressed():
	visible = false


func _on_EquipButton_pressed():
	var selected_item = item_list.get_selected_items()
	if selected_item:
		selected_item = item_list.get_item_text(selected_item[0])
	else:
		return
	emit_signal("character_equipped_item", selected_item, slot_name)
