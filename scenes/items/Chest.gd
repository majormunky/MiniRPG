extends Node2D

enum {
	OPEN,
	CLOSED
}

signal chest_opened(data)

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
		open()
		update_sprite()
		var data = {
			"item": items,
			"chest_id": id
		}
		emit_signal("chest_opened", data)
