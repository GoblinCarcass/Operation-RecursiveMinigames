class_name SpawnerComponent extends Node

signal entity_spawned(entity: Node)

## The dimensions of the scene the Spawner is connected to. If set to 3D while
## in a 2D scene it will load improperly and throw an error.
## [br][br]
## The dimensions are provided explicitly to avoid confusion and odd error handling.
@export_enum("3D", "2D") var entity_dimensions: int

var _spawn_points_2d: Array[Node2D] = []
var _spawn_points_3d: Array[Node3D] = []

func _ready() -> void:
	# Initialize available spawners
	
	var children = self.get_children()
	match entity_dimensions:
		0: # 3D
			for child in children:
				if child is not Node3D:
					assert(false, "The spawn point child of the SpawnerComponent has incorrect dimensions!
					This Spawner only accepts 3D Nodes!")
					continue
				_spawn_points_3d.append(child)
		1: # 2D
			for child in children:
				if child is not Node2D:
					assert(false, "The child of the SpawnerComponent has incorrect dimensions!
					This Spawner only accepts 2D Nodes!")
					continue
				_spawn_points_2d.append(child)


func spawn_entity(entity: Node, spawn_name: String):
	# Step 1: Get the desired entity
	# Step 2: Get the desired destination
	# Step 3: Ship the entity to the destination
	# Simple, right?
	match entity_dimensions:
		0: # 3D
			var spawn_point: Node3D = _get_spawn_point(spawn_name, _spawn_points_3d)
			 
			if null == spawn_point:
				printerr("SpawnerComponent has no 3D spawner children")
				return
			
			if entity is not Node3D:
				printerr("Spawnable entity has incorrent dimensions! It should inherit from Node3D!")
				return
			
			spawn_point.add_child(entity)
			# TODO: Append the entity to the correct parent
			#entity.owner = self.owner
			entity_spawned.emit(entity)
			
		1: # 2D
			var spawn_point: Node2D = _get_spawn_point(spawn_name, _spawn_points_2d)
			
			if null == spawn_point:
				printerr("SpawnerController has no 2D spawner children")
				return
			
			if entity is not Node2D:
				printerr("Spawnable entity has incorrent dimensions! It should inherit from Node2D!")
				return
			
			spawn_point.add_child(entity)
			# TODO: Append the entity to the correct parent
			#entity.owner = self.owner
			entity_spawned.emit(entity)


## Find a specific spawn point by it's name
func _get_spawn_point(name: String, arr: Array) -> Node:
	var spawn_point: Node = null
	for i in arr:
		if i.name != name:
			continue
		spawn_point = i
		break
	return spawn_point
