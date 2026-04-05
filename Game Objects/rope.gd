extends TileMapLayer

@export var platform: Node2D
@export var ceiling_y: float = 200
@export var rope_source_id: int = 0
@export var rope_tile: Vector2i = Vector2i(0, 0)
@export var x_offset: float = 0
@export var y_offset: float = 0  #negative moves rope UP

func _ready():
	clear()

func _process(delta):
	if not platform:
		return
	
	# Position the rope
	global_position.x = platform.global_position.x + x_offset
	global_position.y = ceiling_y + y_offset  # Add offset to ceiling position
	
	clear()
	
	var platform_top = platform.global_position.y
	var rope_length = platform_top - (ceiling_y + y_offset)  # Adjust length calculation
	
	if rope_length <= 0:
		return
	
	var num_tiles = int(rope_length / 16)
	
	for i in range(num_tiles):
		set_cell(Vector2i(0, i), rope_source_id, rope_tile)
