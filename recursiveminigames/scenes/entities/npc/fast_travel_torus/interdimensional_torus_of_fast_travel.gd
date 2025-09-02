extends StaticBody3D

func _on_interaction_started() -> void:
	SceneLoader.change_3d_level(Paths.DAM_TEST_LEVEL)
