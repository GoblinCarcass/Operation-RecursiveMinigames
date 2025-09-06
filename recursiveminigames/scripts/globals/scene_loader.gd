extends Node

# They are instantiated inside of a GameController node
var world_3d: Node3D = null
var world_2d: Node2D = null
var gui: CanvasLayer = null

var current_3d_level: Node3D
var current_2d_level: Node2D
var current_gui_scene: Control

var hidden_scenes: Array[Node] = []
var removed_scenes: Array[Node] = []

func change_3d_level(scene_path: String, delete: bool = true, keep_running: bool = false) -> void:
	if null != current_3d_level:
		if delete:
			current_3d_level.queue_free()
		elif keep_running:
			current_3d_level.visible = false
			hidden_scenes.append(current_3d_level)
		else:
			gui.remove_child(current_3d_level)
			removed_scenes.append(current_3d_level)
	load_scene(scene_path)


func change_2d_level(scene_path: String, delete: bool = true, keep_running: bool = false) -> void:
	if null != current_2d_level:
		if delete:
			current_2d_level.queue_free()
		elif keep_running:
			current_2d_level.visible = false
			hidden_scenes.append(current_2d_level)
		else:
			world_2d.remove_child(current_2d_level)
			removed_scenes.append(current_2d_level)
	load_scene(scene_path)


func change_gui_scene(scene_path: String, delete: bool = true, keep_running: bool = false) -> void:
	if null != current_gui_scene:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
			hidden_scenes.append(current_gui_scene)
		else:
			gui.remove_child(current_gui_scene)
			removed_scenes.append(current_gui_scene)
	load_scene(scene_path)


func load_scene(path: String):
	var new: Node = load(path).instantiate()
	
	if new is Node3D:
		world_3d.add_child(new)
		current_3d_level = new
	elif new is Node2D:
		world_2d.add_child(new)
		current_2d_level = new
	elif new is Control:
		gui.add_child(new)
		current_gui_scene = new
	else:
		assert(false,
		"You are trying to load a scene of incorrect type!
		It should have a root of either Node2D, Node3D or Control!")
		printerr("SceneLoader tried to load a node of an incorrect type.")
	
	#var new = load(scene_path).instantiate()
	#gui.add_child(new)
	#current_gui_scene = new
