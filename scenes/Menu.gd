extends PopupPanel

signal save_game
signal use_inventory_item(item)

onready var item_list = $MarginContainer/HBoxContainer/ItemList
onready var menu_items = {
	"Status": get_node("MarginContainer/HBoxContainer/StatusMenu"),
	"Items": get_node("MarginContainer/HBoxContainer/ItemMenu"),
	"Save": get_node("MarginContainer/HBoxContainer/SaveMenu"),
}
onready var InventoryItem = preload("res://scenes/items/InventoryItem.tscn")
onready var inventory = $MarginContainer/HBoxContainer/ItemMenu/MarginContainer/VBoxContainer/Inventory
onready var use_button = $MarginContainer/HBoxContainer/ItemMenu/MarginContainer/VBoxContainer/HBoxContainer/UseButton

var selected = 0

func _ready():
	print("menu ready")
	for item_key in menu_items:
		item_list.add_item(" " + item_key)
	
	_on_ItemList_item_selected(0)
	item_list.select(0)


func _on_ItemList_item_selected(index):
	selected = index
	item_list.select(index)
	var selectedItem = menu_items.keys()[selected]
	
	if selectedItem == "Save":
		menu_items["Save"].visible = true
		menu_items["Status"].visible = false
		menu_items["Items"].visible = false
	elif selectedItem == "Items":
		menu_items["Items"].visible = true
		menu_items["Status"].visible = false
		menu_items["Save"].visible = false
		update_inventory_page()
	elif selectedItem == "Status":
		menu_items["Status"].visible = true
		menu_items["Save"].visible = false
		menu_items["Items"].visible = false
		update_status_page()


func update_status_page():
	var parent = get_node("MarginContainer/HBoxContainer/StatusMenu/MarginContainer/VBoxContainer")
	parent.get_node("NameLabel").text = "Name: " + PlayerData.player_name
	parent.get_node("CharTypeLabel").text = "Class: " + PlayerData.char_type
	parent.get_node("GoldLabel").text = "Gold: " + str(PlayerData.gold)
	parent.get_node("HPLabel").text = "HP: " + str(PlayerData.current_hp) + "/" + str(PlayerData.max_hp)


func update_inventory_page():
	# for child in inventory_list.get_children():
		# child.queue_free()
	inventory.clear()
	
	for item in PlayerData.inventory:
		# var item_slot = InventoryItem.instance()
		# inventory_list.add_child(item_slot)
		# item_slot.set_data(item)
		inventory.add_item(" " + item.item_name + ": " + str(item.quantity))


func save_game_complete():
	print("Save game complete running")
	menu_items["Save"].get_node("MarginContainer/VBoxContainer/SaveMessage").text = "Save game completed"


func _on_SaveButton_pressed():
	emit_signal("save_game")


func _on_Inventory_item_selected(index):
	print("Inventory item selected: ", index)
	var item_data = PlayerData.inventory[index]
	if item_data.category == "Consumable":
		use_button.visible = true


func _on_UseButton_pressed():
	var selected_item_index = inventory.get_selected_items()[0]
	var selected_item = PlayerData.inventory[selected_item_index]
	selected_item.quantity -= 1
	if selected_item.quantity == 0:
		PlayerData.inventory.remove(selected_item_index)
		inventory.remove_item(selected_item_index)
	else:
		update_inventory_page()
	emit_signal("use_inventory_item", selected_item)
