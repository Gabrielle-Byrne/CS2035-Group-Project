extends CharacterBody2D

@export var foodToFollow: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 100
@export var ACCELERATION: int = 200

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var timer: Timer = $Timer

var direction: Vector2
var left_wander_bounds: Vector2
var right_wander_bounds: Vector2

enum States{
	WANDER,
	SLEEP,
	CHASE
}

var current_state = States.WANDER

func _ready():
	left_wander_bounds = self.position + Vector2(-100, 0)
	right_wander_bounds = self.position + Vector2(0, 100)

func _physics_process(delta: float) -> void:
	pass
	

func _on_timer_timeout() -> void:
	pass # Replace with function body.
