extends GridContainer

var selected = Vector2(0, 0)
var showing_case = "upper"
var state = "selecting"

signal letter_selected(letter)
signal finished_name

func change_case():
	if showing_case == "upper":
		showing_case = "lower"
	else:
		showing_case = "upper"
	setup_letters()


func clear_letters():
	for child in get_children():
		child.queue_free()



func setup_letters():
	clear_letters()
	
	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var lower_alphabet = "abcdefghijklmnopqrstuvwxyz"
	var query_alpha = "QWERTYUIOPASDFGHJKLZXCVBNM"
	
	var selected_alphabet = null
	
	if showing_case == "lower":
		selected_alphabet = lower_alphabet
	elif showing_case == "upper":
		selected_alphabet = alphabet
	
	for letter in selected_alphabet:
		var new_label = RichTextLabel.new()
		new_label.bbcode_enabled = true
		new_label.set_bbcode("[center]" + letter + "[/center]")
		new_label.name = letter
		new_label.rect_min_size.x = 60
		new_label.rect_min_size.y = 80
		new_label.scroll_active = false
		add_child(new_label)
	
	var end_label = RichTextLabel.new()
	end_label.bbcode_enabled = true
	end_label.set_bbcode("[center]end[/center]")
	
	end_label.rect_min_size.x = 120
	end_label.rect_min_size.y = 80
	
	add_child(end_label)
	
	end_label.name = "end"

func _ready():
	setup_letters()
	draw_selected()


func reset_node():
	if selected == null:
		return

	var child_index = selected.y * get_columns() + selected.x
	var selected_node = get_child(child_index)
	selected_node.set_bbcode("[center]" + selected_node.name + "[/center]")


func draw_selected():
	if selected == null:
		return

	var child_index = selected.y * get_columns() + selected.x
	var selected_node = get_child(child_index)
	print(selected_node.text)
	if selected_node:
		selected_node.set_bbcode("[center]>" + selected_node.name + "[/center]")


func get_selected():
	if selected == null:
		return null

	var child_index = selected.y * get_columns() + selected.x
	var selected_node = get_child(child_index)
	return selected_node


func is_valid_node(node):
	var child_index = node.y * get_columns() + node.x
	var selected_node = get_child(child_index)
	if selected_node:
		print(selected_node.name)
		return true
	return false


func _unhandled_input(event):
	if selected == null:
		return

	if event.is_action_released("ui_right"):
		reset_node()
		
		var test_node = Vector2(selected.x + 1, selected.y)
		if is_valid_node(test_node):
			selected.x += 1
		else:
			# wrap around
			selected.x = 0
	elif event.is_action_released("ui_left"):
		reset_node()
		
		var test_node = Vector2(selected.x - 1, selected.y)
		if is_valid_node(test_node):
			selected.x -= 1
	elif event.is_action_released("ui_up"):
		reset_node()

		selected.y -= 1
		if selected.y < 0:
			selected.y = 0
	elif event.is_action_released("ui_down"):
		reset_node()
		
		var test_node = Vector2(selected.x, selected.y + 1)
		# selected.y += 1
		if is_valid_node(test_node):
			selected.y += 1
		else:
			print("Invalid node")
			if selected.y > 2:
				state = "disabled"
				selected = Vector2.ZERO
	elif event.is_action_released("ui_accept"):
		var selected = get_selected()
		if selected.name == "end":
			print("end")
			emit_signal("finished_name")
		else:
			emit_signal("letter_selected", selected.name)
	elif event.is_action_pressed("ui_change_case"):
		print("change case!")
		change_case()
	draw_selected()

