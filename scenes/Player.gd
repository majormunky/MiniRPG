extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200
var inventory = []
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var camera = $Camera2D
onready var sprite = $Sprite
onready var inspect_area = $InspectArea


func _ready():
	print("Character Type ", PlayerData.char_type)
	if PlayerData.char_type == "Warrior":
		sprite.region_rect.position.x = 48 * 4
		sprite.region_rect.position.y = 48 * 4
	elif PlayerData.char_type == "Mage":
		sprite.region_rect.position.x = 0
		sprite.region_rect.position.y = 48 * 5
	elif PlayerData.char_type == "Thief":
		sprite.region_rect.position.x = 48 * 2
		sprite.region_rect.position.y = 48 * 6
	update_map_limits()


func _input(event):
	if event.is_action_pressed("inspect"):
		inspect_area.get_node("CollisionShape2D").disabled = false
		yield(get_tree().create_timer(0.1), "timeout")
		inspect_area.get_node("CollisionShape2D").disabled = true


func update_map_limits():
	print("Updating map limits")
	camera.limit_right = MapData.map_width
	camera.limit_bottom = MapData.map_height


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


func add_item(item_data):
	print("add item - player")
	print(item_data)
