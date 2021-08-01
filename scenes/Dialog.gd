extends PopupPanel

onready var content = $MarginContainer/content

func set_content(text):
	content.text = text
