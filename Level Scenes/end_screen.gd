extends Node2D

@onready var Allen = $Allen

func _process(delta):
	$Allen.play("Allen")
	$Bugby.play("Bug")
	$Allen3.play("Orange")
	$Allen4.play("Yellow")
	$Allen5.play("Pink")
	$Allen6.play("Blue")
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Level Scenes/main_menu.tscn")
