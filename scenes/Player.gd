extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var camera = $Camera2D

# These values will eventually come from a global map info object thing
const map_max_width = 2976
const map_max_height = 1696

func _ready():
	camera.limit_right = map_max_width
	camera.limit_bottom = map_max_height

func _physics_process(delta):
	var input = Vector2.ZERO
	
	input.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	input.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	input = input.normalized()
	
	if input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input);
		animation_tree.set("parameters/Walk/blend_position", input);
		animation_state.travel("Walk")
		velocity = input * speed * delta
	else:
		animation_state.travel("Idle")
		velocity = Vector2.ZERO

	move_and_collide(velocity)
