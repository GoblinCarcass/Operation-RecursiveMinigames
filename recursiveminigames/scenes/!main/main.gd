class_name GameController extends Node


@export_group("Game World")
@export var world_3d: Node3D
@export var world_2d: Node2D
@export var ui_main: CanvasLayer

var current_3d_level: PackedScene
var current_2d_level: PackedScene
var current_gui_scene: PackedScene


func _ready() -> void:
	SceneLoader.game_controller = self
	SceneLoader.world_3d = world_3d
	SceneLoader.world_2d = world_2d
	SceneLoader.ui_main = ui_main
