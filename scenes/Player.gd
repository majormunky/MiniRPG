extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var camera = $Camera2D

# These values will eventually come from a global map info object thing
var map_max_height = MapData.map_height
var map_max_width = MapData.map_width

func update_map_limits():
	print("Updating map limits")
	map_max_height = MapData.map_height
	map_max_width = MapData.map_width
	print("map_max_width", map_max_width)
	print("map_max_height", map_max_height)
	camera.limit_right = map_max_width
	camera.limit_bottom = map_max_height

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
