extends MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	self.rotate_x(0.003)
	self.rotate_z(0.005)
	self.rotate_y(0.002)
