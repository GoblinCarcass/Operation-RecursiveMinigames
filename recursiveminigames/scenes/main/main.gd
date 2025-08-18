class_name GameController extends Node

@onready var madtalk: Node = %MadTalkController
@onready var dialog_manager: DialogManager = %DialogManager
@onready var crosshair: Control = %PlayerCrosshair

@export var dialog_acknowledge_cd: float = 0.4
@export var dialog_start_cd: float = 0.4 

var _can_start_dialog: bool = true
var _can_acknowledge_dialog: bool = true

func _ready() -> void:
	# Important! Those calls are from the game world, not MadTalk node itself.
	SignalBus.dialogue_started.connect(_on_dialog_started)
	SignalBus.dialogue_acknowledged.connect(_on_dialog_acknowledged)
	SignalBus.crosshair_text_changed.connect(_on_crosshair_text_changed)


func _on_dialog_started(id: String) -> void:
	if !_can_start_dialog:
		return
	_can_start_dialog = false
	
	dialog_manager.visible = true
	crosshair.visible = false
	
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
	crosshair.visible = true
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


func _on_crosshair_text_changed(text: String):
	var crosshair_text: Label = crosshair.get_node_or_null("%CrosshairText")
	if crosshair_text:
		crosshair_text.text = text
