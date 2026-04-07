extends Node2D

var currCam = 0

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("reset")):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("change_camera"):
		if(currCam == 0):
			currCam = 1
			$PlayerA_Camera.make_current()
		elif(currCam == 1):
			currCam = 2
			$PlayerB_Camera.make_current()
		else:
			currCam = 0
			$Wide_Camera.make_current()
