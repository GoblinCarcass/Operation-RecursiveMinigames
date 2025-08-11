extends MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	self.rotate_x(0.01)
	self.rotate_z(0.02)
	self.rotate_y(0.03)
