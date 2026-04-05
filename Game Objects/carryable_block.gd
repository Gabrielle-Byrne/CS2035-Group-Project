extends CharacterBody2D

class_name Carryable

var is_carried: bool = false

var is_pushed: bool = false
var direction = 0

var SLIDE_SPEED: float = 60

func _physics_process(delta: float) -> void:
	if !is_carried:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if is_pushed:
			velocity.x = direction * SLIDE_SPEED
		else:
			velocity.x = 0
			
		move_and_slide()
	elif is_carried:
		velocity = Vector2.ZERO

func _on_left_pushable_area_body_entered(body: Node2D) -> void:
	if body.name == "Player_A" or body.name == "Player_B":
		if body.name == "Player_A":
			SLIDE_SPEED = 60
		else:
			SLIDE_SPEED = 30
		direction = 1
		is_pushed = true

func _on_right_pushable_area_body_entered(body: Node2D) -> void:
	if body.name == "Player_A" or body.name == "Player_B":
		if body.name == "Player_A":
			SLIDE_SPEED = 60
		else:
			SLIDE_SPEED = 30
		direction = -1
		is_pushed = true

func _on_left_pushable_area_body_exited(body: Node2D) -> void:
	if body.name == "Player_A" or body.name == "Player_B":
		direction = 0
		is_pushed = false

func _on_right_pushable_area_body_exited(body: Node2D) -> void:
	if body.name == "Player_A" or body.name == "Player_B":
		direction = 0
		is_pushed = false
