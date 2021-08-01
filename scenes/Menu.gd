extends PopupPanel

signal save_game

onready var item_list = $MarginContainer/HBoxContainer/ItemList
onready var menu_items = {
	"Status": get_node("MarginContainer/HBoxContainer/StatusMenu"),
	"Items": get_node("MarginContainer/HBoxContainer/ItemMenu"),
	"Save": get_node("MarginContainer/HBoxContainer/SaveMenu"),
}
var selected = 0

func _ready():
	for item_key in menu_items:
		item_list.add_item(" " + item_key)
	
	_on_ItemList_item_selected(0)
	item_list.select(0)


func _on_ItemList_item_selected(index):
	selected = index
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
	elif selectedItem == "Status":
		menu_items["Status"].visible = true
		menu_items["Save"].visible = false
		menu_items["Items"].visible = false
		get_node("MarginContainer/HBoxContainer/StatusMenu/MarginContainer/VBoxContainer/NameLabel").text = "Name: " + PlayerData.player_name
		get_node("MarginContainer/HBoxContainer/StatusMenu/MarginContainer/VBoxContainer/CharTypeLabel").text = "Class: " + PlayerData.char_type


func save_game_complete():
	menu_items["Save"].get_node("MarginContainer/VBoxContainer/SaveMessage").text = "Save game completed"


func _on_SaveButton_pressed():
	emit_signal("save_game")
