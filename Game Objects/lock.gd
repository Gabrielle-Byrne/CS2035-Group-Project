extends Area2D

func _ready():
	$CollisionShape2D.disabled = false

func _process(delta):
	handleCollisions()
	
func handleCollisions():
	pass
