extends MeshInstance3D

@export_range(0, 1, 0.05) var rot_x 
@export_range(0, 1, 0.05) var rot_y 
@export_range(0, 1, 0.05) var rot_z 

func _ready() -> void:
	if !rot_x:
		rot_x = 0
	if !rot_y:
		rot_y = 0
	if !rot_z:
		rot_z = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	self.rotate_x(rot_x / 100)
	self.rotate_y(rot_y / 100)
	self.rotate_z(rot_z / 100)
