extends VisualInstance3D
@export_range(0, 1, 0.05) var rot_x: float
@export_range(0, 1, 0.05) var rot_y: float
@export_range(0, 1, 0.05) var rot_z: float

const DEFAULT_ROTATION_SPEED := 0.0

func _ready() -> void:
	if rot_x  == 0:
		rot_x = DEFAULT_ROTATION_SPEED
	if rot_y  == 0:
		rot_y = DEFAULT_ROTATION_SPEED
	if rot_z  == 0:
		rot_z = DEFAULT_ROTATION_SPEED

func _physics_process(_delta: float) -> void:
	self.rotate_x(rot_x/ 100)
	self.rotate_y(rot_y / 100)
	self.rotate_z(rot_z / 100)
