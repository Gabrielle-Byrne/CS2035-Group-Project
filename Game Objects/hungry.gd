extends CharacterBody2D

@export var foodToFollow: CharacterBody2D
@export var SPEED: int = 30
@export var CHASE_SPEED: int = 100
@export var ACCELERATION: int = 200
@export var tile: TileMapLayer

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var rays: Array[RayCast2D] = [$AnimatedSprite2D/ray1, $AnimatedSprite2D/ray2, $AnimatedSprite2D/ray3,
$AnimatedSprite2D/ray4, $AnimatedSprite2D/ray5, $AnimatedSprite2D/ray6, $AnimatedSprite2D/ray7]
@onready var ray_down: RayCast2D = $AnimatedSprite2D/ray_down
@onready var wall_detect: RayCast2D = $AnimatedSprite2D/wall_detect

@onready var timer: Timer = $Timer

var direction: Vector2
var left_wander_bounds: Vector2
var right_wander_bounds: Vector2

var currentScaleX: float = 1.92
var currentScaleY: float = 1.955

enum States{
	WANDER,
	IDLE,
	CHASE
}

var current_state = States.IDLE

func _ready():
	left_wander_bounds = self.position + Vector2(-50, 0)
	print(left_wander_bounds)
	right_wander_bounds = self.position + Vector2(50, 0)
	print(right_wander_bounds)
	currentScaleX = currentScaleX * self.scale.x
	currentScaleY = currentScaleY * self.scale.x


func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	look_for_food()
	
	if current_state == States.WANDER or current_state == States.CHASE:
		sprite.play("walking")
	elif current_state == States.IDLE:
		sprite.play("sleeping")

func look_for_food():
	for ray in rays:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("Food"):
				foodToFollow = collider
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
	#Look for ledges
	if is_on_floor() and not ray_down.is_colliding():
		
		#Temporarily disable ray looking for food
		for ray in rays:
			ray.enabled = false
			
		#Turn around if there is no ledge.
		if direction.x == 1:
			direction = Vector2(-1, 0)
			sprite.scale.x = currentScaleX
		elif direction.x == -1:
			direction = Vector2(1, 0)
			sprite.scale.x = -currentScaleX
		
		if current_state == States.CHASE:
			current_state = States.WANDER
		
		#Once turned around, re-enable the rays
		for ray in rays:
			ray.enabled = true
		
		return #Break out of function to prevent chasing or wander
	
	#if wall_detect.is_colliding():
	#	var collider = wall_detect.get_collider()
	#	print(collider.name)
	#	if collider != foodToFollow:
	#		var collision_point = tile.local_to_map(wall_detect.get_collision_point())
	#		var tileAtlas = tile.get_cell_atlas_coords(collision_point)
			
	#		var notAWall: Array = [
	#			Vector2i(0, 5),
	#			Vector2i(1, 5),
	#			Vector2i(2, 5),
	#			Vector2i(3, 5),
	#			Vector2i(4, 5),
	#			Vector2i(5, 5),
	#			Vector2i(6, 5),
	#			Vector2i(7, 5),
	#			Vector2i(12, 5),
	#		]
			
	#		if tileAtlas in notAWall:
	#			return
			#Turn around if there is a wall
	#		if direction.x == 1:
	#			direction = Vector2(-1, 0)
	#			sprite.scale.x = currentScaleX
	#		elif direction.x == -1:
	#			direction = Vector2(1, 0)
	#			sprite.scale.x = -currentScaleX
			
	#		if current_state == States.CHASE:
	#			current_state = States.WANDER
	#		return
	
	if current_state == States.WANDER:
		if direction.x == 1:
			#move to the right
			if self.position.x >= right_wander_bounds.x:
				direction = Vector2(-1, 0)
				sprite.scale.x = currentScaleX
		elif direction.x == -1:
			#move to the left
			if self.position.x <= left_wander_bounds.x:
				#flip right if exceed left bound
				direction = Vector2(1, 0)
				sprite.scale.x = -currentScaleX
		else:
			direction = Vector2(1, 0)
			sprite.scale.x = -currentScaleX
		
		#if sprite.flip_h:
		#	if self.position.x <= right_wander_bounds.x:
		#		direction = Vector2(1, 0)
		#	else:
		#		sprite.flip_h = false
		#		for ray in rays:
		#			ray.target_position.x = -100
				
		#else:
		#	if self.position.x >= left_wander_bounds.x:
		#		direction = Vector2(-1, 0)
		#	else:
		#		sprite.flip_h = true
		#		for ray in rays:
		#			ray.target_position.x = 100
								
	elif current_state == States.CHASE:
		#Switch to following food object. Set direction to where food is.
		#using global position in case food is carried
		direction = (foodToFollow.global_position - self.position).normalized()
		#Get current direction
		direction = sign(direction) 
		#If food is to the right
		if direction.x == 1:
			#flip to right
			#sprite.flip_h = true
			#for ray in rays:
			#	ray.target_position.x = 100
			sprite.scale.x = -currentScaleX
		else:
			#flip to left
			#sprite.flip_h = false
			#for ray in rays:
			#	ray.target_position.x = -100
			sprite.scale.x = currentScaleX

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_timer_timeout() -> void:
	current_state = States.WANDER # Replace with function body.
