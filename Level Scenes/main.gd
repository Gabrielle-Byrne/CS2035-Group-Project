extends Node2D


var can_change = false
#@onready var cameraB = $Player_B/Camera_B
#@onready var cameraA = $Player_A/Camera_A
@onready var camera = $Camera2D
@onready var LevelMusic = $LevelMusic


enum {Player_A, Player_B}
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelMusic.play()
	state = Player_A


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	can_change = true
	
	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene_to_file("res://Level Scenes/level_1.tscn")

	match state:
		Player_A:
			if Input.is_action_just_pressed("switch_character") and can_change == true:
				state = Player_B
				print(state)
				print("A active")
				reset_char_switch_delay()
				#cameraA.make_current()
		Player_B:
			if Input.is_action_just_pressed("switch_character") and can_change == true:
				state = Player_A
				print(state)
				print("B active")
				reset_char_switch_delay()
				#cameraB.make_current()


func reset_char_switch_delay():
	can_change = false
