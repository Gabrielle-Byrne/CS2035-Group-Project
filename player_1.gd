extends CharacterBody2D


const SPEED = 200
const JUMP_VELOCITY = -400.0

const PUSH_FORCE = 50 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("Walk")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		
	if(Input.is_action_just_pressed("ui_left")):
		$AnimatedSprite2D.flip_h = false
	if(Input.is_action_just_pressed("ui_right")):
		$AnimatedSprite2D.flip_h = true
		
	move_and_slide()
	
	for c in get_slide_collision_count():
		var collision = get_slide_collision(c)
		var current_collider = collision.get_collider()
		if current_collider is RigidBody2D:
			if current_collider.is_in_group("pushable") and abs(collision.get_normal().y) < 0.1:
				current_collider.apply_central_impulse(-collision.get_normal() * PUSH_FORCE)
