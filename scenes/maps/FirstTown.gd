extends BaseMap


func _on_TownExit_body_entered(body):
	print("town exit hit")
	emit_signal("location_change", "World")
