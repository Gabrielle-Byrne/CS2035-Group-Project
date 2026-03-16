extends Node2D

var max_time = 1.0
var time_left = 0.0
var can_change = false
@onready var cameraB = $Player_B/Camera_B
@onready var cameraA = $Player_A/Camera_A


enum {Player_A, Player_B}
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	time_left = max_time
	state = Player_A


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_left > 0.0:
		time_left -= delta
		print(time_left)
	elif time_left <= 0.0 and can_change == false:
		print("Can now change characters")
		can_change = true
	
	match state:
		Player_A:
			if Input.is_action_just_pressed("switch_character") and can_change == true:
				state = Player_B
				print(state)
				print("A active")
				reset_char_switch_delay()
				cameraA.make_current()
		Player_B:
			if Input.is_action_just_pressed("switch_character") and can_change == true:
				state = Player_A
				print(state)
				print("B active")
				reset_char_switch_delay()
				cameraB.make_current()


func reset_char_switch_delay():
	time_left = 0
	can_change = false
