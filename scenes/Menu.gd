extends PopupPanel

signal save_game

onready var item_list = $MarginContainer/HBoxContainer/ItemList
onready var menu_items = {
	"Status": get_node("MarginContainer/HBoxContainer/StatusMenu"),
	"Items": get_node("MarginContainer/HBoxContainer/ItemMenu"),
	"Save": get_node("MarginContainer/HBoxContainer/SaveMenu"),
}
onready var InventoryItem = preload("res://scenes/items/InventoryItem.tscn")

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
		menu_items["Save"].get_node("MarginContainer/VBoxContainer/SaveMessage").text = ""
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
	get_node("MarginContainer/HBoxContainer/StatusMenu/MarginContainer/VBoxContainer/NameLabel").text = "Name: " + PlayerData.player_name
	get_node("MarginContainer/HBoxContainer/StatusMenu/MarginContainer/VBoxContainer/CharTypeLabel").text = "Class: " + PlayerData.char_type


func update_inventory_page():
	var inventory_list = get_node("MarginContainer/HBoxContainer/ItemMenu/MarginContainer/VBoxContainer/Inventory")
	for child in inventory_list.get_children():
		child.queue_free()
	
	for item in PlayerData.inventory:
		var item_slot = InventoryItem.instance()
		inventory_list.add_child(item_slot)
		item_slot.set_data(item)


func save_game_complete():
	print("Save game complete running")
	menu_items["Save"].get_node("MarginContainer/VBoxContainer/SaveMessage").text = "Save game completed"


func _on_SaveButton_pressed():
	emit_signal("save_game")
