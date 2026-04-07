extends CharacterBody2D


var colors = ["Blue", "Orange", "Pink","Yellow"]
var levels = ["res://Level Scenes/level_1.tscn", "res://Level Scenes/level_2.tscn", "res://Level Scenes/level_3.tscn", "res://Level Scenes/food_level.tscn", "res://Level Scenes/food_level2.tscn", "res://Level Scenes/snow_level.tscn", "res://Level Scenes/final_level.tscn"]
var level_names = ["Level_1", "Level_2", "Level_3", "Food_level", "Food_level2", "Level3", "final_level"]
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
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("Player"):
			#if(get_tree().current_scene.name=="res://Level Scenes/level_2.tscn"):
				#get_tree().change_scene_to_file("res://Level Scenes/level_1.tscn")
			#else:
				#get_tree().change_scene_to_file("res://Level Scenes/level_2.tscn")
			#break
			var i = level_names.find(get_tree().current_scene.name)
			print(get_tree().current_scene.name)
			if i != -1 and i + 1 < levels.size():
				var next_level = levels[i + 1]
				get_tree().change_scene_to_file(next_level)
			else:
				if !(get_tree().current_scene.name=="res://Level Scenes/end_screen.tscn"):
					get_tree().change_scene_to_file("res://Level Scenes/end_screen.tscn")
