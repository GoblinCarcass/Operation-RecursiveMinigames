extends StaticBody3D

@export var cursor_text: String = "Press E to interact"

func _on_interaction_started() -> void:
	if !MadTalkGlobals.is_during_dialog:
		SignalBus.dialogue_started.emit("test_dialog_with_a_torus")
	#print("Interaction successfully initiated!")
