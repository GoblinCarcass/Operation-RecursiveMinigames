@tool
extends Sprite2D

func _on_texture_changed() -> void:
	queue_redraw()
