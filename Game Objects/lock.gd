extends RigidBody2D

signal keyfree

func _ready():
	$CollisionShape2D.disabled = false

func _physics_process(delta):
	for node in get_colliding_bodies():
		#print("?Collided with: ", node.name)
		if node.is_in_group("Player"):
			if node.has_key == true:
				queue_free()
