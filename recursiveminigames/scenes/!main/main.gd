@tool
class_name GameController extends Node

@onready var world_3d: Node3D = %World3D
@onready var world_2d: Node2D = %World2D
@onready var gui: CanvasLayer = %GUI_Main

@export_group("Default Levels")
@export var default_3d_level: PackedScene
@export var default_2d_level: PackedScene
@export var default_gui_scene: PackedScene
@export_tool_button("Update View", "Callable") var update_view_callable: Callable = update_editor_view
@export_tool_button("Reset View", "Callable") var reset_view_callable: Callable = reset_worlds


func _ready() -> void:
	reset_worlds()
	if !Engine.is_editor_hint():
		# Globals instantiate
		SceneLoader.world_3d = world_3d
		SceneLoader.world_2d = world_2d
		SceneLoader.gui = gui
		
		if null != default_3d_level:
			SceneLoader.change_3d_level(default_3d_level.resource_path)
		if null != default_2d_level:
			SceneLoader.change_2d_level(default_2d_level.resource_path)
		if null != default_gui_scene:
			SceneLoader.change_gui_scene(default_gui_scene.resource_path)


func update_editor_view() -> void:
	if Engine.is_editor_hint():
		var tooltip_3d: Node3D
		var tooltip_2d: Node2D
		var tooltip_gui: Control
		
		reset_worlds()
		if null != default_3d_level:
			tooltip_3d = load(default_3d_level.resource_path).instantiate()
			world_3d.add_child(tooltip_3d)
			tooltip_3d.owner = get_tree().edited_scene_root
		if null != default_2d_level:
			tooltip_2d = load(default_2d_level.resource_path).instantiate()
			world_2d.add_child(tooltip_2d)
			tooltip_2d.owner = get_tree().edited_scene_root
		if null != default_gui_scene:
			tooltip_gui = load(default_gui_scene.resource_path).instantiate()
			gui.add_child(tooltip_gui)
			tooltip_gui.owner = get_tree().edited_scene_root


func reset_worlds() -> void:
		murder_children(world_3d)
		murder_children(world_2d)
		murder_children(gui)


func murder_children(node: Node):
	var children = node.get_children()
	if  children != []:
		for i in children:
			i.queue_free()
