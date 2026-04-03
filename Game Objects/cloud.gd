extends Node2D

@export var player: Node2D
signal blow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func _on_blow_timer_timeout() -> void:
	blow.emit()
