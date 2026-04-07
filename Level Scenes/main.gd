extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if Input.is_action_just_pressed("reset"):
		#get_tree().change_scene_to_file("res://Level Scenes/level_3.tscn")
		get_tree().reload_current_scene()
