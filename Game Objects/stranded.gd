extends CharacterBody2D


var colors = ["Blue", "Orange", "Pink","Yellow"]
var levels = ["res://Level Scenes/level_1.tscn", "res://Level Scenes/level_2.tscn"]
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	$AnimatedSprite2D.animation = colors.pick_random()
	
func _process(delta: float) -> void:
	handleCollisions() 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	$AnimatedSprite2D.play()
	move_and_slide()

	
func handleCollisions():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		print("Collided with: ", collision.get_collider().name)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("Player"):
			if(get_tree().current_scene.name=="res://Level Scenes/level_2.tscn"):
				get_tree().change_scene_to_file("res://Level Scenes/level_1.tscn")
			else:
				get_tree().change_scene_to_file("res://Level Scenes/level_2.tscn")
			break
