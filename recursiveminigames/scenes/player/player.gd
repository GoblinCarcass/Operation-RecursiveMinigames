extends CharacterBody3D

@onready var camera_rotator: Marker3D = $CameraRotator
@onready var camera: Camera3D = $CameraRotator/Camera3D
@onready var model: Node3D = $GirlTutorialTest
@onready var state: StateChart = $StateChart

# Mouse sensitivity
@export var sens_horizontal := 2
@export var sens_vertical := 2

const WALK_SPEED = 5.0
const RUN_SPEED = 20
const JUMP_VELOCITY = 4.5

var _direction: Vector3 = Vector3.ZERO
var _input_dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	handle_camera_rotation(event)


func handle_camera_rotation(event: InputEvent):
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * sens_horizontal / 100)
		camera.rotate_x(-event.relative.y * sens_vertical / 100)
		
		#Limit camera rotation (no cartwheels lmao)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func handle_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta


func handle_jump():
	velocity.y = JUMP_VELOCITY



func handle_movement(speed: float):
	_input_dir = Input.get_vector("left", "right", "up", "down")
	_direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	if _direction:
		velocity.x = _direction.x * speed
		velocity.z = _direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

# One Giant State Machine: Proceed with caution!

func _on_idle_state_physics_processing(delta: float) -> void:
	_input_dir = Input.get_vector("left", "right", "up", "down")
	if _input_dir:
		state.send_event("to_walking")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state.send_event("to_jumping")
	
	handle_gravity(delta)
	move_and_slide()


func _on_walking_state_physics_processing(delta: float) -> void:
	_input_dir = Input.get_vector("left", "right", "up", "down")
	
	if !_input_dir:
		state.send_event("to_idle")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state.send_event("to_jumping")
	if Input.is_action_pressed("sprint"):
		state.send_event("to_running")
	
	handle_movement(WALK_SPEED)
	handle_gravity(delta)
	move_and_slide()


func _on_running_state_physics_processing(delta: float) -> void:
	if Input.is_action_just_released("sprint"):
		state.send_event("to_walking")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state.send_event("to_jumping")
	
	handle_movement(RUN_SPEED)
	handle_gravity(delta)
	move_and_slide()

func _on_jumping_state_entered() -> void:
	handle_jump()
	state.send_event("stop_jumping")
