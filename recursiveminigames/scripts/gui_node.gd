class_name GUINode extends Control

@export_group("Dialog")
@export var dialog_acknowledge_cd: float = 0.4
@export var dialog_start_cd: float = 0.4 

@onready var madtalk: MadTalkRuntime = %MadTalkController
@onready var dialog_manager: DialogManager = %DialogManager

var _can_start_dialog: bool = true
var _can_acknowledge_dialog: bool = true

func _ready() -> void:
	connect_signals()
	


func _on_tree_exited() -> void:
	disconnect_signals()
	

func _on_dialog_started(id: String) -> void:
	#print("The dialog signal works as intended!")
	if !_can_start_dialog:
		return
	
	_can_start_dialog = false
	SignalBus.dialog_box_visibility_set.emit(true)
	SignalBus.crosshair_visibility_changed.emit(false)
	SignalBus.player_movement_mode_set.emit(false)
	SignalBus.player_can_rotate_camera_mode_set.emit(false)
	
	madtalk.start_dialog(id)


func _on_dialog_acknowledged():
	if _can_acknowledge_dialog:
		madtalk.dialog_acknowledge()
	
	_can_acknowledge_dialog = false
	create_oneshot_timer(_on_dialog_acknowledge_cd_timeout, dialog_acknowledge_cd)

 
func _on_dialog_acknowledge_cd_timeout() -> void:
	_can_acknowledge_dialog = true


func _on_madtalk_dialog_finished(_sheet_name: Variant, _sequence_id: Variant):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	SignalBus.dialog_box_visibility_set.emit(false)
	SignalBus.crosshair_visibility_changed.emit(true)
	SignalBus.player_movement_mode_set.emit(true)
	SignalBus.player_can_rotate_camera_mode_set.emit(true)
	
	create_oneshot_timer(_on_dialog_started_cd_timeout, dialog_start_cd)


func _on_dialog_started_cd_timeout() -> void:
	_can_start_dialog = true


func _on_madtak_dialog_started(_sheet_name: Variant, _sequence_id: Variant):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE




func create_oneshot_timer(callable: Callable, wait_time: float):
	var dialog_timer: Timer = Timer.new()
	dialog_timer.timeout.connect(_on_dialog_acknowledge_cd_timeout)
	dialog_timer.wait_time = wait_time
	dialog_timer.autostart = true
	dialog_timer.one_shot = true
	add_child(dialog_timer)


func connect_signals():
	SignalBus.dialog_started.connect(_on_dialog_started)
	SignalBus.dialog_acknowledged.connect(_on_dialog_acknowledged)
	madtalk.dialog_started.connect(_on_madtak_dialog_started)
	madtalk.dialog_finished.connect(_on_madtalk_dialog_finished)


func disconnect_signals():
	if SignalBus.dialog_started.is_connected(_on_dialog_started):
		SignalBus.dialog_started.disconnect(_on_dialog_started)
	if SignalBus.dialog_acknowledged.is_connected(_on_dialog_acknowledged):
		SignalBus.dialog_acknowledged.disconnect(_on_dialog_acknowledged)
	if madtalk.dialog_started.is_connected(_on_madtak_dialog_started):
		madtalk.dialog_started.disconnect(_on_madtak_dialog_started)
	if madtalk.dialog_finished.is_connected(_on_madtalk_dialog_finished):
		madtalk.dialog_finished.disconnect(_on_madtalk_dialog_finished)
