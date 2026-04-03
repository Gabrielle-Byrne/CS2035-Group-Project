extends Node2D

var window_size: Vector2
const speed = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_size = get_window().size
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(position.x < -window_size.x/2 || position.x > window_size.x):
		queue_free()
	position.x = position.x - speed*delta
