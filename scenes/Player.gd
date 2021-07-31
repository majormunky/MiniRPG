extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200

func _physics_process(delta):
	var input = Vector2.ZERO
	
	input.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	input.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	input = input.normalized()
	
	if input != Vector2.ZERO:
		velocity = input * speed * delta
	else:
		velocity = Vector2.ZERO

	move_and_collide(velocity)
