extends CharacterBody2D

var speed = 200
var is_following = false
var target = null

func _process(delta):
	handleCollisions()
	
func handleCollisions():
	# Iterate through all collisions that occurred this frame
	print("s")
	for  index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		print(collision)
		#for reasons we won't go into here, collision detection is
		#complicated and we may get a null collision, skip it!
		if collision.get_collider() == null:
			continue
		# If the collider is with player
		if collision.get_collider().is_in_group("Player"):
			target = collision
			is_following = true
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
