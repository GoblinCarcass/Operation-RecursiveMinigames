extends Node3D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	rotation.y -=0.2 * delta
