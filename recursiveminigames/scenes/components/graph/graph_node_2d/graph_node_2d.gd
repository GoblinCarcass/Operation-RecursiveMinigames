@tool
class_name GraphNode2D extends Area2D

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var sprite_2d: Sprite2D = %Sprite2D

@export var connections: Array[GraphConnection2D] = []:
	get = get_connections,
	set = set_connections
func get_connections() -> Array[GraphConnection2D]:
	return connections
func set_connections(value: Array[GraphConnection2D]):
	for child in self.get_children():
		if child is GraphConnection2D:
			child.queue_free()
	for v in value:
		connections.append(v)
		self.add_child(v)

@export_group("Exports")
@export var shape_export: Shape2D = null
@export var sprite_export: Texture2D = null


func _ready() -> void:
	if null != shape_export:
		collision_shape_2d.shape = shape_export
	if null != sprite_export:
		sprite_2d.texture = sprite_export
	queue_redraw()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if collision_shape_2d.shape != shape_export:
			collision_shape_2d.shape = shape_export
		if sprite_2d.texture != sprite_export:
			sprite_2d.texture = sprite_export
			queue_redraw()
	else:
		pass
