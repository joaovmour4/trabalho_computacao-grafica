extends KinematicBody

const GRAVITY := 20
const JUMP_FORCE := 10

var mouse_sensitivy := 0.3
var show_mouse := false
var direction := Vector3()
var velocity := Vector3()
var speed := 5
var acceleration := 10
var vertical_velocity := 0.0

onready var head : Spatial = $Head

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivy))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivy))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-170), deg2rad(0))


func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		show_mouse = !show_mouse
		if show_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			
func _physics_process(delta: float) -> void:
	_movement(delta)
	_jump()
	
	
func _movement(delta: float) -> void:
	var body_rotation = global_transform.basis.get_euler().y
	direction = Vector3(Input.get_axis("ui_left", "ui_right"), 0, Input.get_axis("ui_up", "ui_down")).rotated(Vector3.UP, body_rotation)
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP)
	
	if not is_on_floor():
		vertical_velocity -= GRAVITY * delta
	else:
		vertical_velocity = 0


func _jump() -> void:
	if Input.is_action_pressed("ui_select") and is_on_floor():
		vertical_velocity = JUMP_FORCE



