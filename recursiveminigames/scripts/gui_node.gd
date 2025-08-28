extends Control

@export_group("Dialogue")
@export var dialog_acknowledge_cd: float = 0.4
@export var dialog_start_cd: float = 0.4 

@onready var madtalk: MadTalkRuntime = %MadTalkController
@onready var dialog_manager: DialogManager = %DialogManager

var _can_start_dialog: bool = true
var _can_acknowledge_dialog: bool = true

func _ready() -> void:
	SignalBus.dialogue_started.connect(_on_dialog_started)
	SignalBus.dialogue_acknowledged.connect(_on_dialog_acknowledged)
	madtalk.dialog_started.connect(_on_madtak_dialog_started)


func _on_dialog_started(id: String) -> void:
	if !_can_start_dialog:
		return
	
	_can_start_dialog = false
	SignalBus.dialogue_box_visibility_set.emit(true)
	SignalBus.crosshair_visibility_changed.emit(false)
	SignalBus.player_movement_mode_set.emit(false)
	madtalk.start_dialog(id)


func _on_dialog_acknowledged():
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


func _on_dialog_finished(_sheet_name: Variant, _sequence_id: Variant):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	SignalBus.dialogue_box_visibility_set.emit(false)
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


func _on_madtak_dialog_started(_sheet_name: Variant, _sequence_id: Variant):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
