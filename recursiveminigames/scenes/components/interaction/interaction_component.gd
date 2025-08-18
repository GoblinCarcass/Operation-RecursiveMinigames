class_name InteractionComponent extends Area3D

signal interaction_started

@export_multiline var cursor_text: String = ""

# Called externally by the player
func interact() -> void:
	interaction_started.emit()


func get_cursor_text() -> String:
	return cursor_text


func set_cursor_text(text: String):
	cursor_text = text
