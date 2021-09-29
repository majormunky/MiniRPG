extends GridContainer

var selected = Vector2(0, 0)

signal letter_selected(letter)

func setup_letters():
	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for letter in alphabet:
		var new_label = RichTextLabel.new()
		new_label.bbcode_enabled = true
		new_label.set_bbcode("[center]" + letter + "[/center]")
		new_label.name = letter
		new_label.rect_min_size.x = 60
		new_label.rect_min_size.y = 80
		new_label.scroll_active = false
		add_child(new_label)


func _ready():
	setup_letters()
	draw_selected()


func reset_node():
	var child_index = selected.y * get_columns() + selected.x
	var selected_node = get_child(child_index)
	selected_node.set_bbcode("[center]" + selected_node.name + "[/center]")


func draw_selected():
	var child_index = selected.y * get_columns() + selected.x
	var selected_node = get_child(child_index)
	selected_node.set_bbcode("[center]>" + selected_node.name + "[/center]")


func get_selected():
	var child_index = selected.y * get_columns() + selected.x
	var selected_node = get_child(child_index)
	return selected_node


func _unhandled_input(event):
	if event.is_action_released("ui_right"):
		reset_node()
		selected.x += 1
	elif event.is_action_released("ui_left"):
		reset_node()
		selected.x -= 1
		if selected.x < 0:
			selected.x = 7
			selected.y = 2
	elif event.is_action_released("ui_up"):
		reset_node()
		selected.y -= 1
		if selected.y < 0:
			selected.y = 2
	elif event.is_action_released("ui_down"):
		reset_node()
		selected.y += 1
		if selected.y > 2:
			selected.y = 0
	elif event.is_action_released("ui_accept"):
		var selected = get_selected()
		emit_signal("letter_selected", selected.name)
	draw_selected()
		
