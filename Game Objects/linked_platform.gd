extends Node2D

@export var move_speed: float = 100.0
@export var raised_position: Vector2 = Vector2.ZERO

var start_position: Vector2
var target_position: Vector2
var is_moving: bool = false
var boxes_on_platform: Array[Carryable] = []

func _ready():
	start_position = position
	target_position = position
	
	var detector = $BoxDetector if has_node("BoxDetector") else null
	if detector:
		detector.body_entered.connect(_on_detector_body_entered)
		detector.body_exited.connect(_on_detector_body_exited)

func _on_detector_body_entered(body: Node2D):
	if body is Carryable:
		if body not in boxes_on_platform:
			boxes_on_platform.append(body)

func _on_detector_body_exited(body: Node2D):
	if body is Carryable:
		if body in boxes_on_platform:
			boxes_on_platform.erase(body)

func move_to_raised():
	target_position = raised_position
	is_moving = true

func _process(delta: float):
	if is_moving:
		var old_position = position
		position = position.move_toward(target_position, move_speed * delta)
		var movement = position - old_position
		
		for box in boxes_on_platform:
			if is_instance_valid(box):
				box.position += movement
		
		if position == target_position:
			is_moving = false
