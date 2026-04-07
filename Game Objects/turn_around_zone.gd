extends Area2D

signal turnAround

func _on_body_entered(body: Node2D) -> void:
	print("Entered")
	if body.is_in_group("HungryBoi"):
		turnAround.emit(body)
