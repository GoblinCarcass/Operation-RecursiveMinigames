class_name GB_GraphNode extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

## Exported texture of the node
@export var texture_export: Texture2D = null
## Exported shape of the node collision
@export var collision_shape_export: Shape2D = null

func _ready() -> void:
	#TODO: Add connections to other nodes and make them automatically show in the editor
	if null != texture_export:
		sprite_2d.texture = texture_export
		sprite_2d.queue_redraw()
	if null != collision_shape_export:
		collision_shape_2d.shape = collision_shape_export
		
