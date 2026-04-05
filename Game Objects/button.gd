extends Node2D

var pressed : bool

signal button_pressed
signal button_unpressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed = false
	$AnimatedSprite2D.play("default")
	$StaticBody2D/CollisionShape2D.shape.size.y = 14
	$StaticBody2D/CollisionShape2D.position.y = 2

func _on_button_top_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		pressed = true
		$AnimatedSprite2D.play("pressed")
		$StaticBody2D/CollisionShape2D.shape.size.y = 10
		$StaticBody2D/CollisionShape2D.position.y = 4
		button_pressed.emit()

func _on_button_top_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		pressed = false
		$AnimatedSprite2D.play("default")
		$StaticBody2D/CollisionShape2D.shape.size.y = 14
		$StaticBody2D/CollisionShape2D.position.y = 2
		button_unpressed.emit()
