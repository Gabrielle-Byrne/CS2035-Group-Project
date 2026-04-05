extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	position = Vector2(320, 240)
	$AnimatedSprite2D.animation = "Yellow"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	$AnimatedSprite2D.play()
