class_name PlayerSpawnerComponent extends Node

@export_enum("3D", "2D") var player_dimensions: int
@export var player_character: PackedScene

var player: Node
var spawners_2d: Array[Marker2D] = []
var spawners_3d: Array[Marker3D] = []


func _ready() -> void:
	var children = self.get_children()
	for child in children:
		if child is Marker2D:
			spawners_2d.append(child)
		elif child is Marker3D:
			spawners_3d.append(child)
