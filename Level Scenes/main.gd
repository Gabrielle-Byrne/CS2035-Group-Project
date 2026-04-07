extends Node2D

var currCam = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if Input.is_action_just_pressed("reset"):
		#get_tree().change_scene_to_file("res://Level Scenes/level_3.tscn")
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("change_camera"):
		if(currCam == 0):
			currCam = 1
		elif(currCam == 1):
			currCam = 2
		else:
			currCam = 0
