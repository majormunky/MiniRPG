extends BaseMap


func _on_Town_body_entered(body):
	emit_signal("location_change", "FirstTown")
