extends Node2D

@export var move_speed: float = 100.0
@export var end_position: Vector2 = Vector2.ZERO
@export var controlling_button: Node2D

var start_position: Vector2
var target_position: Vector2
var is_moving: bool = false
var boxes_on_platform: Array[Carryable] = []

func _ready():
	start_position = position
	target_position = start_position
	
	if controlling_button:
		controlling_button.button_pressed.connect(_on_button_pressed)
		controlling_button.button_unpressed.connect(_on_button_unpressed)

func _on_button_pressed():
	target_position = end_position
	is_moving = true

func _on_button_unpressed():
	target_position = start_position
	is_moving = true

func _process(delta: float):
	if is_moving:
		var old_position = position
		position = position.move_toward(target_position, move_speed * delta)
		var movement = position - old_position
		
		# Move all boxes that are on the platform
		for box in boxes_on_platform:
			if is_instance_valid(box):
				box.position += movement
		
		if position == target_position:
			is_moving = false


func _on_box_detector_body_entered(body: Node2D) -> void:
	if body is Carryable:
		if body not in boxes_on_platform:
			boxes_on_platform.append(body)


func _on_box_detector_body_exited(body: Node2D) -> void:
	if body is Carryable:
		if body in boxes_on_platform:
			boxes_on_platform.erase(body)
