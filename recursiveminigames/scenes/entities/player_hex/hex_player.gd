extends CharacterBody2D

@onready var raycast_container: Node2D = $Raycasts

var coords: Vector2i = Vector2i(-1, -1)
var raycasts: Array[RayCast2D] = []

func _ready() -> void:
	for node in raycast_container.get_children():
		if node is RayCast2D:
			#print(node)
			raycasts.append(node)
