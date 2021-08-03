extends PopupPanel

onready var content = $MarginContainer/content
var lines = []
var current_line = null
var keep_open = false


func set_content(text):
	content.text = text


func open_dialog(text_lines):
	lines = text_lines
	current_line = 0
	set_content(lines[current_line]["text"])
	visible = true
	keep_open()


func keep_open():
	keep_open = true
	yield(get_tree().create_timer(0.5), "timeout")
	keep_open = false

func next():
	current_line += 1
	if len(lines) >= current_line + 1:
		set_content(lines[current_line]["text"])
		keep_open()
	else:
		close_dialog()


func close_dialog():
	set_content("")
	lines = []
	current_line = null
	visible = false
