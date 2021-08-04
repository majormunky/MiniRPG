extends BaseMap


func _on_Town_body_entered(_body):
	emit_signal("location_change", "FirstTown")


func _on_NPCSpawnTest_body_entered(body):
	print("spawn npc")
	emit_signal("enemy_spawn", {"ground_type": "desert"})
