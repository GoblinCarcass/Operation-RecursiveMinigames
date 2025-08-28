class_name GameController extends Node

@onready var world_3d: Node3D = %World3D
@onready var world_2d: Node2D = %World2D
@onready var ui_main: CanvasLayer = %UI_Main


@export_group("Default Levels")
@export var default_3d_level: PackedScene
@export var default_2d_level: PackedScene
@export var default_gui_scene: PackedScene

var current_3d_level: PackedScene
var current_2d_level: PackedScene
var current_gui_scene: PackedScene


func _ready() -> void:
	SceneLoader.game_controller = self
	
	#TODO: Create the level changing mechanism
	if default_3d_level:
		#change_current_3d_level(default_3d_level)
		pass
	if default_2d_level:
		#change_current_2d_level(default_2d_level)
		pass
	if default_gui_scene:
		#change_current_gui_scene(default_gui_scene)
		pass
	
	SceneLoader.world_3d = world_3d
	SceneLoader.world_2d = world_2d
	SceneLoader.ui_main = ui_main
