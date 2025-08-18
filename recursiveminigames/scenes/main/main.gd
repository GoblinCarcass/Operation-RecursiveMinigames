class_name GameController extends Node

@onready var madtalk: Node = %MadTalkController
@onready var dialog_manager: DialogManager = %DialogManager
@onready var crosshair: Control = %PlayerCrosshair
@onready var interaction_cd: Timer = %InteractionCD

func _ready() -> void:
	# Important! Those calls are from the game world, not MadTalk node itself.
	SignalBus.dialogue_started.connect(_on_dialog_started)
	SignalBus.dialogue_acknowledged.connect(_on_dialog_acknowledged)


func _on_dialog_started(id: String):
	if !interaction_cd.is_stopped():
		return
	dialog_manager.visible = true
	crosshair.visible = false
	madtalk.start_dialog(id)
	SignalBus.player_movement_mode_set.emit(false)
	
func _on_dialog_acknowledged():
	madtalk.dialog_acknowledge()

 
func _on_mad_talk_controller_dialog_started(sheet_name: Variant, sequence_id: Variant) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

 
func _on_dialog_finished(sheet_name: Variant, sequence_id: Variant) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	dialog_manager.visible = false
	crosshair.visible = true
	SignalBus.player_movement_mode_set.emit(true)
	interaction_cd.start()
