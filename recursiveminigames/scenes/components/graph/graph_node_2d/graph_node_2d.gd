@tool
class_name GraphNode2D extends Area2D

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var sprite_2d: Sprite2D = %Sprite2D

@export var connections: Array[GraphNode2D] = []:
	get: return connections
	set(value): connections = value
@export_group("Exports")
@export var shape_export: Shape2D = null
@export var sprite_export: Texture2D = null


func _init() -> void:
	print(collision_shape_2d)


func _ready() -> void:
	print(collision_shape_2d)
	if !Engine.is_editor_hint():
		if null != shape_export:
			collision_shape_2d.shape = shape_export
			pass
		if null != sprite_export:
			sprite_2d.texture = sprite_export
			pass
		queue_redraw()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		pass
		# TODO: Why in the fuck does this not work properly?
		# It pushes an error because collision_shape_2d hasn't loaded yet, but how in the fuck am I supposed
		# to load it in the editor script? It makes no sense. 
		
		#if shape_export != collision_shape_2d.shape and collision_shape_2d.is_node_ready():
			#collision_shape_2d.shape  = shape_export
			#queue_redraw()
		#if sprite_export != sprite_2d.texture and sprite_2d.is_node_ready():
			#sprite_2d.texture = sprite_export
			#queue_redraw()
