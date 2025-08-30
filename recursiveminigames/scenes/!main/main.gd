class_name GameController extends Node

@onready var world_3d: Node3D = %World3D
@onready var world_2d: Node2D = %World2D
@onready var gui: CanvasLayer = %GUI_Main

#TODO: add a tool script that updates the Editor window with loaded scenes 
@export_group("Default Levels")
@export var default_3d_level: PackedScene
@export var default_2d_level: PackedScene
@export var default_gui_scene: PackedScene

func _ready() -> void:
	SceneLoader.game_controller = self
	SceneLoader.world_3d = world_3d
	SceneLoader.world_2d = world_2d
	SceneLoader.gui = gui
	
	if default_3d_level != null:
		SceneLoader.change_3d_level(default_3d_level.resource_path)
	if default_2d_level != null:
		SceneLoader.change_2d_level(default_2d_level.resource_path)
	if default_gui_scene != null:
		SceneLoader.change_gui_scene(default_gui_scene.resource_path)
