extends Node2D

const SPEED = 50
var direction = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y = clamp(position.y + direction * SPEED * delta, -220, 220)
	



func _on_button_up_button_pressed() -> void:
	direction = -1

func _on_button_down_button_pressed() -> void:
	direction = 1

func _on_button_unpressed() -> void:
	direction = 0
