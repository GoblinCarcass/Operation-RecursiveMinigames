class_name SpawnerComponent extends Node

signal entity_spawned(entity: Node)

## The dimensions of the scene the Spawner is connected to. If set to 3D while
## in a 2D scene it will load improperly and throw an error.
## [br][br]
## The dimensions are provided explicitly to avoid confusion and odd error handling.
@export_enum("3D", "2D") var dimensions: int

var _last_spawned_entity: Node = null
var _spawned_entites: Array[Node] = []
var _spawn_points_2d: Array[Node2D] = []
var _spawn_points_3d: Array[Node3D] = []


func _ready() -> void:
	# Initialize available spawners. Preferably they should be Marker2D and 3D nodes,
	# but any node will do just fine. Remember to keep the model below (0, 0) coords though.
	# You wouldn't want the player to spawn in the middle of a mesh now, would you?
	
	var children = self.get_children()
	match dimensions:
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
					assert(false,
					"The child of the SpawnerComponent has incorrect dimensions!
					This Spawner only accepts 2D Nodes!")
					continue
				_spawn_points_2d.append(child)


## Find a specific spawn point by it's name. It should be slightly faster than the regular String.
func _get_spawn_point(node_name: String, arr: Array) -> Node:
	var spawn_point: Node = null
	for i in arr:
		if i.name != node_name:
			continue
		spawn_point = i
		break
	return spawn_point


func _setup_entity_in_scene_tree(entity: Node, spawn_point: Node):
	self.get_parent().add_child(entity)
	_spawned_entites.append(entity)
	_last_spawned_entity = entity
	entity.position.x = spawn_point.position.x
	entity.position.y = spawn_point.position.y
	if dimensions == 0: #3D 
		entity.position.z = spawn_point.position.z
	entity.global_rotation = spawn_point.global_rotation
	entity_spawned.emit(entity)


func spawn_entity(entity: Node, spawn_name: String):
	# Step 1: Get the desired entity
	# Step 2: Get the desired destination
	# Step 3: Ship the entity to the destination
	# Simple, right?
	match dimensions:
		0: # 3D
			var spawn_point: Node3D = _get_spawn_point(spawn_name, _spawn_points_3d)
			if null == spawn_point:
				printerr("SpawnerComponent has no 3D spawner children")
				return
			if entity is not Node3D:
				printerr("Spawnable entity has incorrent dimensions! It should inherit from Node3D!")
				return
			
			_setup_entity_in_scene_tree(entity, spawn_point)
			
		1: # 2D
			var spawn_point: Node2D = _get_spawn_point(spawn_name, _spawn_points_2d)
			if null == spawn_point:
				printerr("SpawnerController has no 2D spawner children")
				return
			if entity is not Node2D:
				printerr("Spawnable entity has incorrent dimensions! It should inherit from Node2D!")
				return
			
			_setup_entity_in_scene_tree(entity, spawn_point)


func remove_entities():
	for entity in _spawned_entites:
		entity.queue_free()
	_spawned_entites.clear()


func remove_last_entity():
	if null != _last_spawned_entity:
		_last_spawned_entity.queue_free()
