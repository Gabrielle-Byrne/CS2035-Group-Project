extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("native_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("native_left", "native_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
	
	if(Input.is_action_just_pressed("native_left")):
		$AnimatedSprite2D.flip_h = false
	if(Input.is_action_just_pressed("native_right")):
		$AnimatedSprite2D.flip_h = true 
	
	move_and_slide()
