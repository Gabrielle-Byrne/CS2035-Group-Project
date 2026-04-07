extends Node2D

const SPEED = 1

@export var player: Node2D

@onready var rays = $WindAreas.get_children()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for ray in rays:
		var collider = ray.get_collider()
		if(collider and collider.is_in_group("Player")):
			collider.wind_speed += 100

	position.y = clamp(move_toward(position.y, player.position.y, SPEED), -250, 270)
