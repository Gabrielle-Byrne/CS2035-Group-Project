extends Node2D

@export var move_speed: float = 100.0
@export var lowered_position: Vector2 = Vector2.ZERO
@export var raised_position: Vector2 = Vector2.ZERO
@export var required_boxes: int = 4
@export var linked_platform: Node2D = null
@export var control_button: Node2D = null
@export var locked_box_layer: TileMapLayer = null
@export var number_tilemap: TileMapLayer = null
@export var number_cell: Vector2i = Vector2i(0, 0)
@export var number_source_id: int = 0
@export var number_tiles: Dictionary = {
	4: Vector2i(0, 0),
	3: Vector2i(1, 0),
	2: Vector2i(2, 0),
	1: Vector2i(3, 0),
	0: Vector2i(4, 0)
}

var start_position: Vector2
var target_position: Vector2
var is_moving: bool = false
var boxes_on_platform: Array[Carryable] = []
var is_unlocked: bool = false
var is_triggered: bool = false

func _ready():
	start_position = position
	target_position = position
	
	# Start with locked box visible and collision enabled, button hidden
	if locked_box_layer:
		locked_box_layer.visible = true
		locked_box_layer.collision_enabled = true
	
	if control_button:
		control_button.visible = false
	
	# Initialize number display
	update_number_display(required_boxes)
	
	if control_button:
		control_button.button_pressed.connect(_on_button_pressed)
	
	# Setup platform detector
	var detector = $BoxDetector if has_node("BoxDetector") else null
	if detector:
		detector.body_entered.connect(_on_detector_body_entered)
		detector.body_exited.connect(_on_detector_body_exited)

func update_number_display(remaining_boxes: int):
	if not number_tilemap:
		return
	
	var display_count = clamp(remaining_boxes, 0, required_boxes)
	
	if number_tiles.has(display_count):
		var tile_coords = number_tiles[display_count]
		number_tilemap.set_cell(number_cell, number_source_id, tile_coords)

func _on_detector_body_entered(body: Node2D):
	if body is Carryable:
		if body not in boxes_on_platform:
			boxes_on_platform.append(body)
			body.set_platform(self)
			check_box_count()

func _on_detector_body_exited(body: Node2D):
	if body is Carryable:
		if body in boxes_on_platform:
			boxes_on_platform.erase(body)
			body.clear_platform()
			check_box_count()

func check_box_count():
	var count = boxes_on_platform.size()
	var remaining = required_boxes - count
	
	# Update the number display
	update_number_display(remaining)
	
	if count >= required_boxes and not is_triggered:
		is_unlocked = true
		# Hide the locked box layer AND disable collision
		if locked_box_layer:
			locked_box_layer.visible = false
			locked_box_layer.collision_enabled = false
		# Show the button
		if control_button:
			control_button.visible = true
	elif count < required_boxes and not is_triggered:
		is_unlocked = false
		if control_button:
			control_button.visible = false
		# Show the locked box layer AND enable collision again
		if locked_box_layer:
			locked_box_layer.visible = true
			locked_box_layer.collision_enabled = true

func _on_button_pressed():
	if is_unlocked and not is_triggered:
		is_triggered = true
		
		# Move this platform to lowered position
		target_position = lowered_position
		is_moving = true
		
		# Move linked platform to raised position
		if linked_platform and linked_platform.has_method("move_to_raised"):
			linked_platform.move_to_raised()

func _process(delta: float):
	if is_moving:
		var old_position = position
		position = position.move_toward(target_position, move_speed * delta)
		var movement = position - old_position
		
		# Move boxes on platform
		for box in boxes_on_platform:
			if is_instance_valid(box):
				box.position += movement
		
		if position == target_position:
			is_moving = false

func move_to_raised():
	if not is_triggered:
		target_position = raised_position
		is_moving = true
