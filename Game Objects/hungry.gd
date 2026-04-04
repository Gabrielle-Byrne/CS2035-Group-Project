extends CharacterBody2D

@export var foodToFollow: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 100
@export var ACCELERATION: int = 200

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var timer: Timer = $Timer

var direction: Vector2
var left_wander_bounds: Vector2
var right_wander_bounds: Vector2

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance:= 100
var angle_between_rays := deg_to_rad(5.0)

enum States{
	WANDER,
	SLEEP,
	CHASE
}

var current_state = States.WANDER

func _ready():
	left_wander_bounds = self.position + Vector2(-100, 0)
	right_wander_bounds = self.position + Vector2(0, 100)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	generate_raycast()
	change_direction()
	look_for_food()
	
	if current_state == States.WANDER or current_state == States.CHASE:
		sprite.play("walking")

func generate_raycast() -> void:
	var ray_count = angle_cone_of_vision/angle_between_rays
	
	for i in ray_count:
		var ray = RayCast2D.new()
		var angle: float = angle_between_rays * (i - ray_count/2)
		ray.target_position = Vector2.LEFT.rotated(angle) * max_view_distance
		add_child(ray)
		ray.enabled = true

func look_for_food():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == foodToFollow:
			chase_food()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()
			
func chase_food() -> void:
	timer.stop()
	current_state = States.CHASE

func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta: float) -> void:
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	elif current_state == States.CHASE:
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELERATION * delta)
	move_and_slide()

func change_direction() -> void:
	if current_state == States.WANDER:
		if sprite.flip_h:
			if self.position.x <= right_wander_bounds.x:
				direction = Vector2(1, 0)
			else:
				sprite.flip_h = false
				ray_cast.target_position = Vector2(-100, 0)
		else:
			if self.position.x >= left_wander_bounds.x:
				direction = Vector2(-1, 0)
			else:
				sprite.flip_h = true
				ray_cast.target_position = Vector2(100, 0)
	elif current_state == States.CHASE:
		#Switch to following food object. Set direction to where food is
		direction = (foodToFollow.position - self.position).normalized()
		
		#Get current direction
		direction = sign(direction)  
		#If food is on the right
		if direction.x == 1:
			#flip to right
			sprite.flip_h = true
			ray_cast.target_position = Vector2(100, 0)
		else:
			#flip to left
			sprite.flip_h = false
			ray_cast.target_position = Vector2(-100, 0)
			
func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_timer_timeout() -> void:
	current_state = States.WANDER # Replace with function body.
