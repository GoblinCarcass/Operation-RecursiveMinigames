extends StaticBody3D
@onready var animation: AnimationPlayer = $Mesh/AnimationPlayer

var isOpen: bool = false

func _on_interaction_component_interaction_started() -> void:
	if isOpen == false:
		animation.play("entrance door open")
		isOpen = true
	else:
		animation.play_backwards("entrance door open")
		isOpen = false
