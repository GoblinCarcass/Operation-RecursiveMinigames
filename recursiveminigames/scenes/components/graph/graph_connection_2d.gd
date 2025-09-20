class_name GraphConnection2D extends Line2D

@export var from: GraphNode2D
@export var to: GraphNode2D

func update() -> void:
	clear_points()
	if from != null:
		add_point(Vector2(from.global_position.x, from.global_position.y))
	if to != null:
		add_point(Vector2(to.global_position.x, to.global_position.y))
	queue_redraw()
