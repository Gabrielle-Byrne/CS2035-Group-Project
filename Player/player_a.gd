extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -400.0
const PUSH_FORCE = 50
const MAX_VELOCITY = 100
var has_key = false

@export var wind_speed = 0

var is_in_range: bool = false
var target_object: Node2D

var facingDirection

@onready var JumpSound : AudioStreamPlayer2D = $JumpSound
@onready var PickupSound = $PickupSound

var held_object: Node2D

@onready var carry_position: Marker2D = $CarryPosition

func _ready():
	$AnimatedSprite2D.play("A")
	has_key = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("a_jump") and is_on_floor():
		JumpSound.play()
		velocity.y = JUMP_VELOCITY
	
	if position.y < -1000:
		position.y = 100;
		position.x = 100;

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("a_left", "a_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("A")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		
	if Input.is_action_just_pressed("a_left"):
		$AnimatedSprite2D.flip_h = false
		facingDirection = "left"
	if Input.is_action_just_pressed("a_right"):
		$AnimatedSprite2D.flip_h = true
		facingDirection = "right"
	
	# Handle pushing blocks (CharacterBody2D version)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var block = collision.get_collider()
		if is_instance_valid(block) and block.is_in_group("Block") and abs(block.velocity.x) < MAX_VELOCITY:
			block.velocity.x += collision.get_normal().x * -PUSH_FORCE
			#block.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
		if is_instance_valid(block) and block.is_in_group("Lock") and has_key:
			block.call_deferred("queue_free") 
	
		
	if held_object:
		drop_object()
	else:
		pickup_object()
	
		
	velocity.x -= wind_speed
	wind_speed = 0
	move_and_slide()

func pickup_object() -> void:
	if is_in_range:
		if Input.is_action_just_pressed("a_pickup") and !held_object:
			held_object = target_object
			held_object.is_carried = true
			held_object.reparent(carry_position)
			held_object.position = carry_position.position

func drop_object() -> void:
	if held_object:
		if Input.is_action_just_pressed("a_pickup"):
			held_object.reparent(get_tree().current_scene)
			if facingDirection == "left":
				held_object.position = position + Vector2.LEFT * 20
			elif facingDirection == "right":
				held_object.position = position + Vector2.RIGHT * 20
			held_object.is_carried = false
			held_object = null
			
func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is Carryable:
		is_in_range = true
		target_object = body

func _on_pickup_range_body_exited(body: Node2D) -> void:
	if body is Carryable:
		is_in_range = false
		target_object = null

func _on_key_keyed() -> void:
	has_key = true
