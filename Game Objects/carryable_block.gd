extends CharacterBody2D

class_name Carryable

var is_carried: bool = false

func _physics_process(delta: float) -> void:
	if !is_carried:
		if not is_on_floor():
			velocity += get_gravity() * delta
			move_and_slide()
	else:
		velocity = Vector2.ZERO
