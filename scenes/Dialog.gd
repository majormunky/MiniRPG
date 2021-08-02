extends PopupPanel

onready var content = $MarginContainer/content

var keep_open = false

func set_content(text):
	content.text = text

func open_dialog(text):
	set_content(text)
	keep_open = true
	visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	keep_open = false


func close_dialog():
	set_content("")
	visible = false
