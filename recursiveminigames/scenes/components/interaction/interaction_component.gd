class_name InteractionComponent extends Area3D

## Emitted when the player starts an interaction with the connected entity.
signal interaction_started

@export_multiline var cursor_text: String = "": set = set_cursor_text, get = get_cursor_text
func set_cursor_text(new_value: String):
	cursor_text = new_value
func get_cursor_text() -> String:
	return cursor_text


# Called externally by the player
func interact() -> void:
	interaction_started.emit()
