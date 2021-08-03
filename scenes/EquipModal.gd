extends WindowDialog


onready var item_list = $VBoxContainer/ItemList


func setup(item_type):
	print("Item Type: ", item_type)
