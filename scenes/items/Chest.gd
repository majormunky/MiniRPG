extends Node2D

enum {
	OPEN,
	CLOSED
}

signal chest_opened(data)
signal chest_already_opened()

var state = CLOSED
var items = []
var id = null

onready var open_sprite = $OpenChest
onready var closed_sprite = $ClosedChest


func _ready():
	update_sprite()


func update_sprite():
	if state == OPEN:
		open_sprite.visible = true
		closed_sprite.visible = false
	elif state == CLOSED:
		open_sprite.visible = false
		closed_sprite.visible = true


func open():
	state = OPEN

func _on_Area2D_area_entered(_area):
	print("Chest interacted with")
	if state == CLOSED:
		if GameData.dialog_open:
			print("A dialog is open, bail out here and not open the chest")
			return
		open()
		update_sprite()
		var data = {
			"item": items,
			"chest_id": id
		}
		emit_signal("chest_opened", data)
	elif state == OPEN:
		print("Emitting signal - chest_already_opened")
		emit_signal("chest_already_opened")
