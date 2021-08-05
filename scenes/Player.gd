extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var camera = $Camera2D
onready var sprite = $Sprite
onready var inspect_area = $InspectArea

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

	velocity = move_and_collide(velocity)


func add_item(item_data):
	print("add item - player")
	var test_item = item_data.item[0]
	var item_stats = ItemData.items[test_item.item]
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

	print(PlayerData.inventory)
