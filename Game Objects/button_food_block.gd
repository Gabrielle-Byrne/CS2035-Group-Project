extends TileMapLayer


func _on_button_button_pressed() -> void:
	set_cell(Vector2i(0, 1), -1, Vector2i(6,1))
	set_cell(Vector2i(0, 1), -1, Vector2i(6,2))
	set_cell(Vector2i(0, 1), -1, Vector2i(5,3))
	set_cell(Vector2i(0, 1), -1, Vector2i(5,7))

func _on_button_button_unpressed() -> void:
	pass # Replace with function body.
