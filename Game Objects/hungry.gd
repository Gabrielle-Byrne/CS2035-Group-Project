extends CharacterBody2D

@export var foodToFollow: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 80
@export var ACCELERATION: int = 200

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var rays: Array[RayCast2D] = [$AnimatedSprite2D/ray1, $AnimatedSprite2D/ray2, $AnimatedSprite2D/ray3,
$AnimatedSprite2D/ray4, $AnimatedSprite2D/ray5, $AnimatedSprite2D/ray6, $AnimatedSprite2D/ray7]

@onready var timer: Timer = $Timer

var direction: Vector2
var left_wander_bounds: Vector2
var right_wander_bounds: Vector2

var angle_cone_of_vision := deg_to_rad(45.0)
var max_view_distance:= 200
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
	change_direction()
	look_for_food()
	
	if current_state == States.WANDER or current_state == States.CHASE:
		sprite.play("walking")


func look_for_food():
	for ray in rays:
		if ray.is_colliding():
			var collider = ray.get_collider()
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
				for ray in rays:
					ray.target_position.x = -100
				
		else:
			if self.position.x >= left_wander_bounds.x:
				direction = Vector2(-1, 0)
			else:
				sprite.flip_h = true
				for ray in rays:
					ray.target_position.x = 100

				
	elif current_state == States.CHASE:
		#Switch to following food object. Set direction to where food is.
		#using global position in case food is carried
		direction = (foodToFollow.global_position - self.position).normalized()
		#Get current direction
		direction = sign(direction) 
		#If food is to the right
		if direction.x == 1:
			#flip to right
			sprite.flip_h = true
			for ray in rays:
				ray.target_position.x = 100
		else:
			#flip to left
			sprite.flip_h = false
			for ray in rays:
				ray.target_position.x = -100

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_timer_timeout() -> void:
	current_state = States.WANDER # Replace with function body.
