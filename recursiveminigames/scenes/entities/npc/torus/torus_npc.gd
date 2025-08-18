extends StaticBody3D

func _on_interaction_started() -> void:
	if !MadTalkGlobals.is_during_dialog:
		SignalBus.dialogue_started.emit("test_dialog_with_a_torus")
	#print("Interaction successfully initiated!")
