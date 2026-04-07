extends Label

@export var A : CharacterBody2D
@export var B : CharacterBody2D
var fade = 300
var min_alpha = 0

func _process(delta: float) -> void:
	if A or B:
		var distanceA = global_position.distance_to(A.global_position)
		var distanceB = global_position.distance_to(B.global_position)
		var transparency = clamp(min(distanceA,distanceB)/fade, min_alpha, 1.0)
		modulate.a = 1-transparency
