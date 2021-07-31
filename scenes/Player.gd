extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree


func _physics_process(delta):
	var input = Vector2.ZERO
	
	input.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	input.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	input = input.normalized()
	
	if input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input);
		animation_tree.set("parameters/Walk/blend_position", input);
		velocity = input * speed * delta
	else:
		
		velocity = Vector2.ZERO

	move_and_collide(velocity)
