extends CharacterBody3D

@onready var camera_rotator: Marker3D = %CameraRotator
@onready var camera: Camera3D = %PlayerCamera
@onready var model: Node3D = %Model
@onready var state: StateChart = %StateChart
@onready var i_ray: RayCast3D = %InteractionRaycast

@export_range(2, 10, 0.2) var mouse_sensitivity: float

const WALK_SPEED := 5.0
const RUN_SPEED := 10.0
const JUMP_VELOCITY = 4.5

var _input_dir: Vector2 = Vector2.ZERO
var _direction: Vector3 = Vector3.ZERO
var _i_object: Node3D = null # Collider of the InteractionRaycast
var _can_move: bool = true
var _can_rotate_camera: bool = true


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.player_movement_mode_set.connect(_on_movement_mode_set)
	SignalBus.player_can_rotate_camera_mode_set.connect(_on_camera_rotation_mode_set)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_camera_rotation(event)
	if event.is_action_pressed("interaction"):
		handle_interaction()
	if event.is_action_pressed("dialog_continue"):
		if not MadTalkGlobals.is_during_dialog:
			return
		SignalBus.dialog_acknowledged.emit()


func _physics_process(_delta: float) -> void:
	_i_object = i_ray.get_collider()
	if _i_object:
		if not _i_object.is_in_group("interactable"):
			return
		SignalBus.crosshair_text_changed.emit(_i_object.get_cursor_text())
	else:
		SignalBus.crosshair_text_changed.emit(" ")


func _on_movement_mode_set(mode: bool):
	_can_move = mode


func _on_camera_rotation_mode_set(mode: bool):
	_can_rotate_camera = mode


# One Giant State Machine: Proceed with caution! ===================================================

func _on_idle_state_physics_processing(delta: float) -> void:
	_input_dir = Input.get_vector("left", "right", "up", "down")
	
	if _input_dir:
		state.send_event("to_walking")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state.send_event("to_jumping")
	
	handle_gravity(delta)
	move_and_slide()


func _on_walking_state_physics_processing(delta: float) -> void:
	handle_movement(WALK_SPEED)
	handle_gravity(delta)
	move_and_slide()
	
	if not _input_dir:
		state.send_event("to_idle")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state.send_event("to_jumping")
	if Input.is_action_pressed("sprint"):
		state.send_event("to_running")
	


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


# End of a Giant State Machine =====================================================================


func handle_interaction() -> void:
	_i_object = i_ray.get_collider()
	if not _i_object:
		return
	if _i_object.is_in_group("interactable"):
		_i_object.interact()


func handle_camera_rotation(event: InputEvent) -> void:
	if not _can_rotate_camera:
		return
	
	self.rotate_y(-event.relative.x * mouse_sensitivity / 500)
	self.camera_rotator.rotate_x(-event.relative.y * mouse_sensitivity / 500)
	
	#It turns off camera cartwheels lmao
	camera_rotator.rotation.x = clampf(camera_rotator.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func handle_jump() -> void:
	if not _can_move:
		return
	velocity.y = JUMP_VELOCITY



func handle_movement(speed: float) -> void:
	if not _can_move:
		return
		
	_input_dir = Input.get_vector("left", "right", "up", "down")
	_direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if _direction:
		velocity.x = _direction.x * speed
		velocity.z = _direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


func _on_tree_exited():
	if SignalBus.player_movement_mode_set.is_connected(_on_movement_mode_set):
		SignalBus.player_movement_mode_set.disconnect(_on_movement_mode_set)
	if SignalBus.player_can_rotate_camera_mode_set.is_connected(_on_camera_rotation_mode_set):
		SignalBus.player_can_rotate_camera_mode_set.disconnect(_on_camera_rotation_mode_set)
