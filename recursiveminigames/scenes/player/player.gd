extends CharacterBody3D

@onready var camera_rotator: Marker3D = $CameraRotator
@onready var camera: Camera3D = $CameraRotator/Camera3D
@onready var model: Node3D = $GirlTutorialTest

# Mouse sensitivity
@export var sens_horizontal := 2
@export var sens_vertical := 2

const SPEED = 5.0
const RUN_SPEED = 20
const JUMP_VELOCITY = 4.5


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
		#Handle camera rotation
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * sens_horizontal / 100)
		camera.rotate_x(-event.relative.y * sens_vertical / 100)
		
		#Limit camera rotation (no cartwheels lmao)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
