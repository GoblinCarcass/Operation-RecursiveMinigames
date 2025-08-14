extends CharacterBody3D

@onready var camera_rotator: Marker3D = %CameraRotator
@onready var camera: Camera3D = %PlayerCamera
@onready var model: Node3D = %Model
@onready var state: StateChart = %StateChart
@onready var i_ray: RayCast3D = %InteractionRaycast

@export_range(0, 10, 0.2) var mouse_sensitivity: float

const DEFAULT_MOUSE_SENSITIVITY := 2.4
const WALK_SPEED := 5.0
const RUN_SPEED := 10.0
const JUMP_VELOCITY = 4.5

## The direction of the WSAD input
var _input_dir: Vector2 = Vector2.ZERO
## The actual direction the player is moving to (includes jumping)
var _direction: Vector3 = Vector3.ZERO

var can_move: bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.player_movement_mode_set.connect(_on_movement_mode_set)
	if mouse_sensitivity == 0:
		mouse_sensitivity = DEFAULT_MOUSE_SENSITIVITY



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_camera_rotation(event)
	if event.is_action("interaction"):
		handle_interaction()
	if event.is_action("dialogue_continue"):
		# TODO: It doesn't recognize left click as continue imput even though it is on the list
		if MadTalkGlobals.is_during_dialog:
			SignalBus.dialogue_acknowledged.emit()


# Signals! =========================================================================================

func _on_movement_mode_set(mode: bool):
	can_move = mode

# End of Signals! ==================================================================================


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
	
	if !_input_dir:
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
	var i_object: Node3D = i_ray.get_collider()
	if !i_object:
		return
	if i_object.is_in_group("interactable"):
		i_object.interact()


func handle_camera_rotation(event: InputEvent) -> void:
	self.rotate_y(-event.relative.x * mouse_sensitivity / 500)
	self.camera_rotator.rotate_x(-event.relative.y * mouse_sensitivity / 500)
	
	#It turns off camera cartwheels lmao
	camera_rotator.rotation.x = clampf(camera_rotator.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func handle_jump() -> void:
	if !can_move:
		return
	velocity.y = JUMP_VELOCITY



func handle_movement(speed: float) -> void:
	if !can_move:
		return
		
	_input_dir = Input.get_vector("left", "right", "up", "down")
	_direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if _direction:
		velocity.x = _direction.x * speed
		velocity.z = _direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
