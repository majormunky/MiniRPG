extends BaseMap


func _on_Town_body_entered(_body):
	emit_signal("location_change", "FirstTown")
