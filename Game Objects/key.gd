extends CharacterBody2D

var speed = 200
var is_following = false
var target = null


func _ready():
	$CollisionShape2D.disabled = false

func _process(delta):
	handleCollisions()
	
func handleCollisions():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		print("Collided with: ", collision.get_collider().name)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("Player"):
			target = collision
			is_following = true
			$CollisionShape2D.set_deferred("disabled", true)
			break


#func _on_area_2d_body_entered(body):
	#print("check")
	#if body.is_in_group("Player"):
		#print("s")
		#target = body
		#is_following = true

func _physics_process(delta):
	if is_following and target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		
func _unlock():
	queue_free()
