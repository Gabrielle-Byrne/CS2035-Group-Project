extends Camera2D

@export var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x = clamp(player.position.x, -295, 312)
	position.y = clamp(player.position.y, -158, 1000)
	
