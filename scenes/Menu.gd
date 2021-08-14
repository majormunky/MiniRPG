extends PopupPanel

signal save_game
signal use_inventory_item(item)

onready var item_list = $MarginContainer/HBoxContainer/ItemList
onready var menu_items = {
	"Status": get_node("MarginContainer/HBoxContainer/StatusMenu"),
	"Items": get_node("MarginContainer/HBoxContainer/ItemMenu"),
	"Save": get_node("MarginContainer/HBoxContainer/SaveMenu"),
}

onready var CharacterSlot = preload("res://scenes/characters/CharacterSlot.tscn")
onready var InventoryItem = preload("res://scenes/items/InventoryItem.tscn")
onready var inventory = $MarginContainer/HBoxContainer/ItemMenu/MarginContainer/VBoxContainer/Inventory
onready var use_button = $MarginContainer/HBoxContainer/ItemMenu/MarginContainer/VBoxContainer/HBoxContainer/UseButton
onready var equip_modal = $MarginContainer/EquipModal

var selected = 0
var selectedItem = null

func _ready():
	print("menu ready")
	for item_key in menu_items:
		item_list.add_item(" " + item_key)
	
	_on_ItemList_item_selected(0)
	item_list.select(0)


func close_menu():
	visible = false
	equip_modal.visible = false
	_on_ItemList_item_selected(0)


func _on_ItemList_item_selected(index):
	print("Running item list selected")
	selected = index
	item_list.select(index)
	selectedItem = menu_items.keys()[selected]
	update_panels()


func update_panels():
	var char_info_panel = get_node("MarginContainer/HBoxContainer/CharacterInfoMenu")
	if selectedItem == "Save":
		menu_items["Save"].visible = true
		menu_items["Status"].visible = false
		menu_items["Items"].visible = false
		char_info_panel.visible = false
		menu_items["Save"].get_node("MarginContainer/VBoxContainer/SaveMessage").text = ""
	elif selectedItem == "Items":
		menu_items["Items"].visible = true
		menu_items["Status"].visible = false
		menu_items["Save"].visible = false
		char_info_panel.visible = false
		update_inventory_page()
	elif selectedItem == "Status":
		menu_items["Status"].visible = true
		menu_items["Save"].visible = false
		menu_items["Items"].visible = false
		char_info_panel.visible = false
		update_status_page()
	elif selectedItem == "CharacterInfo":
		menu_items["Status"].visible = false
		menu_items["Save"].visible = false
		menu_items["Items"].visible = false
		char_info_panel.visible = true


func update_character_info(data):
	# print(data)
	var parent = get_node("MarginContainer/HBoxContainer/CharacterInfoMenu/VBoxContainer/HBoxContainer2")
	parent.get_node("MarginContainer/VBoxContainer/Name/Data").text = data["character_name"]
	parent.get_node("MarginContainer/VBoxContainer/Exp/Data").text = str(data["experience"])
	parent.get_node("MarginContainer/VBoxContainer/HP/Data").text = str(data["current_hp"]) + "/" + str(data["max_hp"])
	parent.get_node("MarginContainer/VBoxContainer/Job/Data").text = data["type"]
	parent.get_node("MarginContainer/VBoxContainer/Strength/Data").text = str(data["str"])
	parent.get_node("MarginContainer/VBoxContainer/Dexterity/Data").text = str(data["dex"])
	parent.get_node("MarginContainer/VBoxContainer/Intelligence/Data").text = str(data["int"])
	parent.get_node("MarginContainer/VBoxContainer/Attack/Data").text = calculate_attack(data)
	parent.get_node("MarginContainer/VBoxContainer/Defense/Data").text = calculate_defense(data)


func calculate_defense(char_data):
	return str(int(char_data["dex"] * 0.5 + char_data["str"] * 0.5))


func calculate_attack(char_data):
	return str(int(char_data["str"] * 1.25))


func update_status_page():
	var parent = get_node("MarginContainer/HBoxContainer/StatusMenu/MarginContainer/VBoxContainer")
	var character_row_1 = parent.get_node("CharacterContainer/CharacterRow1")
	var character_row_2 = parent.get_node("CharacterContainer/CharacterRow2")
	
	for child in character_row_1.get_children():
		child.queue_free()
	
	for child in character_row_2.get_children():
		child.queue_free()
	
	# we always will have this character
	var main_character = PlayerData.characters[0]
	var slot1 = CharacterSlot.instance()
	character_row_1.add_child(slot1)
	slot1.update_data(main_character)
	
	slot1.connect("info_button_clicked", self, "on_info_button_clicked")
	
	if len(PlayerData.characters) > 1:
		var char2 = PlayerData.characters[1]
		var slot2 = CharacterSlot.instance()
		character_row_1.add_child(slot2)
		slot2.update_data(char2)
		slot2.connect("info_button_clicked", self, "on_info_button_clicked")
	
	if len(PlayerData.characters) > 2:
		var char3 = PlayerData.characters[2]
		var slot3 = CharacterSlot.instance()
		character_row_2.add_child(slot3)
		slot3.update_data(char3)
		slot3.connect("info_button_clicked", self, "on_info_button_clicked")
	
	if len(PlayerData.characters) > 3:
		var char4 = PlayerData.characters[3]
		var slot4 = CharacterSlot.instance()
		character_row_2.add_child(slot4)
		slot4.update_data(char4)
		slot4.connect("info_button_clicked", self, "on_info_button_clicked")


func on_info_button_clicked(data):
	selectedItem = "CharacterInfo"
	update_character_info(data)
	update_panels()


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


func _on_InfoBackButton_pressed():
	_on_ItemList_item_selected(0)
	item_list.select(0)


func equip_item(slot_name):
	print("need to equip item in slot: ", slot_name)
	equip_modal.setup(slot_name)
	equip_modal.popup()


func _on_HelmetChangeButton_pressed():
	equip_item("Helmet")


func _on_ChestChangeButton_pressed():
	equip_item("Chest")


func _on_ArmsChangeButton_pressed():
	equip_item("Arms")


func _on_LegsChangeButton_pressed():
	equip_item("Legs")


func _on_BootsChangeButton_pressed():
	equip_item("Boots")
