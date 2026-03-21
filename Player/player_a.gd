extends CharacterBody2D


const SPEED = 200
const JUMP_VELOCITY = -400.0
const PUSH_FORCE = 50
const MAX_VELOCITY = 100

func _ready():
	$AnimatedSprite2D.play("A")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("a_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("a_left", "a_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("A")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		
	if(Input.is_action_just_pressed("a_left")):
		$AnimatedSprite2D.flip_h = false
	if(Input.is_action_just_pressed("a_right")):
		$AnimatedSprite2D.flip_h = true
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var block = collision.get_collider()
		if block.is_in_group("Block") and abs(block.get_linear_velocity().x) < MAX_VELOCITY:
			block.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)

	move_and_slide()
