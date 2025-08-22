class_name GameController extends Node


@export_group("Game World")
@export var world_3d: Node3D
@export var world_2d: Node2D
@export var ui_main: CanvasLayer

var current_3d_level:PackedScene
var current_2d_level:PackedScene
var current_gui_scene:PackedScene

@export_group("Dialogue")
@export var dialog_acknowledge_cd: float = 0.4
@export var dialog_start_cd: float = 0.4 

@onready var madtalk: Node = %MadTalkController
@onready var dialog_manager: DialogManager = %DialogManager
var _can_start_dialog: bool = true
var _can_acknowledge_dialog: bool = true

func _ready() -> void:
	SceneLoader.game_controller = self
	SceneLoader.world_3d = world_3d
	SceneLoader.world_2d = world_2d
	SceneLoader.ui_main = ui_main
	
	SignalBus.dialogue_started.connect(_on_dialog_started)
	SignalBus.dialogue_acknowledged.connect(_on_dialog_acknowledged)

func _on_dialog_started(id: String) -> void:
	if !_can_start_dialog:
		return
	_can_start_dialog = false
	
	dialog_manager.visible = true
	SignalBus.crosshair_visibility_changed.emit(false)
	
	madtalk.start_dialog(id)
	SignalBus.player_movement_mode_set.emit(false)


func _on_dialog_acknowledged() -> void:
	if _can_acknowledge_dialog:
		madtalk.dialog_acknowledge()
	_can_acknowledge_dialog = false
	
	var dialog_timer: Timer = Timer.new()
	dialog_timer.timeout.connect(_on_dialog_acknowledge_cd_timeout)
	dialog_timer.wait_time = dialog_acknowledge_cd
	dialog_timer.one_shot = true
	dialog_timer.autostart = true
	add_child(dialog_timer)

 
func _on_dialog_acknowledge_cd_timeout() -> void:
	_can_acknowledge_dialog = true


func _on_dialog_finished(sheet_name: Variant, sequence_id: Variant) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	dialog_manager.visible = false
	SignalBus.crosshair_visibility_changed.emit(true)
	SignalBus.player_movement_mode_set.emit(true)
	
	var dialog_timer: Timer = Timer.new()
	dialog_timer.timeout.connect(_on_dialog_started_cd_timeout)
	dialog_timer.wait_time = dialog_start_cd
	dialog_timer.autostart = true
	dialog_timer.one_shot = true
	add_child(dialog_timer)


func _on_dialog_started_cd_timeout() -> void:
	_can_start_dialog = true


func _on_mad_talk_controller_dialog_started(sheet_name: Variant, sequence_id: Variant) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
