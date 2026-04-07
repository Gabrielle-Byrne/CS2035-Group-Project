extends CharacterBody2D


const SPEED = 200
const JUMP_VELOCITY = -600.0
const PUSH_FORCE = 100
const MAX_VELOCITY = 100

var has_key = false

@onready var JumpSound = $JumpSound

@export var wind_speed = 0

func _ready():
	$AnimatedSprite2D.play("B")
	has_key = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("b_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		JumpSound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("b_left", "b_right")
	if direction:
		velocity.x = direction * (SPEED - wind_speed)
		$AnimatedSprite2D.play("B")
		
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED-wind_speed))
		$AnimatedSprite2D.stop()
		
	if(Input.is_action_just_pressed("b_left")):
		$AnimatedSprite2D.flip_h = false
	if(Input.is_action_just_pressed("b_right")):
		$AnimatedSprite2D.flip_h = true
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var block = collision.get_collider()
		if is_instance_valid(block) and block.is_in_group("Lock") and has_key:
			block.call_deferred("queue_free") 
	
	velocity.x -= wind_speed
	wind_speed = 0
	move_and_slide()


func _key_check() -> bool:
	return has_key
	
func _on_key_keyed() -> void:
	has_key = true # Replace with function body.
