extends Node2D

signal monster_died(monster_id)
signal monster_health_changed(monster_id, new_health)

var monster_id = null
var health = 12
var experience_given = 10
var gold_given = 5
var items_given = []


func die():
	emit_signal("monster_died", monster_id)
	queue_free()


func take_damage(val):
	health -= val
	if health <= 0:
		die()
		return
	
	emit_signal("monster_health_changed", monster_id, health)
