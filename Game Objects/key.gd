extends CharacterBody2D

var speed = 200
var is_following = false
var target = null
signal keyed

func _ready():
	$CollisionShape2D.disabled = false

func _process(delta):
	handleCollisions()
	
func handleCollisions():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("Player"):
			target = collision.get_collider()
			is_following = true
			keyed.emit()
			$CollisionShape2D.set_deferred("disabled", true)
			break


func _physics_process(delta):
	if is_following and target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		move_and_slide()
		
func _unlock():
	queue_free()
