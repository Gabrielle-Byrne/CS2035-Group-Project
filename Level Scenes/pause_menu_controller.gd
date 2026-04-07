extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused
		
	


func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Level Scenes/main_menu.tscn")
