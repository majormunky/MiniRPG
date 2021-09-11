extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var camera = $Camera2D
onready var sprite = $Sprite
onready var inspect_area = $InspectArea
onready var ray = $RayCast2D

const WALKING_SPEED = 4.0
const TILE_SIZE = 32
const HALF_TILE_SIZE = TILE_SIZE / 2

var initial_position = Vector2.ZERO
var input_direction = Vector2.ZERO
var is_moving = false
var percent_moved = 0.0

signal player_inspected

func _ready():
	var main_char_type = PlayerData.characters[0].type
	# var char_type_data = ""
	if main_char_type == "Warrior":
		sprite.region_rect.position.x = 48 * 4
		sprite.region_rect.position.y = 48 * 4
	elif main_char_type == "Mage":
		sprite.region_rect.position.x = 0
		sprite.region_rect.position.y = 48 * 5
	elif main_char_type == "Thief":
		sprite.region_rect.position.x = 48 * 2
		sprite.region_rect.position.y = 48 * 6
	elif main_char_type == "Cleric":
		sprite.region_rect.position.x = 48 * 3
		sprite.region_rect.position.y = 48 * 6
	update_map_limits()
	initial_position = position


func _input(event):
	if event.is_action_pressed("inspect"):
		inspect_area.get_node("CollisionShape2D").disabled = false
		yield(get_tree().create_timer(0.1), "timeout")
		inspect_area.get_node("CollisionShape2D").disabled = true
		emit_signal("player_inspected")


func update_map_limits():
	print("Updating map limits")
	camera.limit_right = MapData.map_width
	camera.limit_bottom = MapData.map_height


func _physics_process(delta):
	if GameData.dialog_open:
		return

	if is_moving == false:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.get_action_strength("walk_right")) - int(Input.get_action_strength("walk_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.get_action_strength("walk_down")) - int(Input.get_action_strength("walk_up"))
	
	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true


func move(delta):
	percent_moved += WALKING_SPEED * delta
	var desired_step = input_direction * TILE_SIZE / 2
	ray.cast_to = desired_step
	ray.force_raycast_update()
	if !ray.is_colliding():
		
		if percent_moved >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			is_moving = false
			percent_moved = 0.0
			animation_state.travel("Idle")
		else:		
			position = initial_position + (TILE_SIZE * input_direction * percent_moved)
		
			animation_tree.set("parameters/Idle/blend_position", input_direction);
			animation_tree.set("parameters/Walk/blend_position", input_direction);
			animation_state.travel("Walk")
	else:
		is_moving = false
		animation_state.travel("Idle")


func add_item(item_data):
	print("add item - player")
	var test_item = item_data.item[0]
	var item_stats = GameData.item_data[test_item.item]
	var add_health = null
	if item_stats.has("add_health"):
		add_health = item_stats["add_health"]
	
	var new_item = {
		"stack_size": item_stats["stack_size"],
		"category": item_stats["category"],
		"add_health": add_health,
		"description": item_stats["description"],
		"image_name": item_stats["image_name"],
		"id": test_item["id"],
		"item_name": test_item["item"],
		"quantity": test_item["quantity"],
		"consumable_type": null,
		"slot": item_stats["slot"],
	}
	if item_stats["category"] == "Consumable":
		new_item["consumable_type"] = item_stats["consumable_type"]
	
	# flag to see if we have found an existing slot to put the item into
	var found_spot = false
	
	# go over the players inventory item by item
	for existing_item in PlayerData.inventory:
		# check if the existing items name matches our new item name
		if existing_item["item_name"] == new_item["item_name"]:
			# if so, we need to see if we can add this item to the slot
			# we do this by first calculating what our new stack size would be
			var new_amount = existing_item["quantity"] + new_item["quantity"]
			
			# and then we check that against the stack size
			if new_amount <= existing_item["stack_size"]:
				# if we can add it, we do
				existing_item["quantity"] += new_item["quantity"]
				# and set our flag to say we found a spot
				found_spot = true
		
	# if we didn't find a spot
	if found_spot == false:
		# just add this as a new item
		PlayerData.inventory.append(new_item)
