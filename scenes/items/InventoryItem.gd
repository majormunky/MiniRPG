extends HBoxContainer

var item_name = null
var quantity = null
var stack_size = null
onready var item_name_label = $ItemNameLabel
onready var item_quantity_label = $ItemQuantityLabel


func set_data(data):
	item_name = data["item_name"]
	quantity = data["quantity"]
	stack_size = data["stack_size"]
	
	item_name_label.text = item_name
	item_quantity_label.text = str(quantity)
