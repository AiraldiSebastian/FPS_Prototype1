extends KinematicBody

# ----------------------------------
# Physics

export (float) var GRAVITY;

# Kinematic
export (int) var MAX_SPEED;
export (int) var JUMP_SPEED;
export (int) var MAX_SPRINT_SPEED;
export (float) var ACCEL;
export (float) var DEACCEL;
export (float) var SPRINT_ACCEL;
var vel = Vector3()
var dir = Vector3()
var is_sprinting : bool = false
# ----------------------------------

# ----------------------------------
# Others

const MAX_SLOPE_ANGLE = 45

var camera
var rotation_helper

# Mouse
var MOUSE_SENSITIVITY = 0.05
var mouse_scroll_value = 0
const MOUSE_SENSITIVITY_SCROLL_WHEEL = 0.08


var flashlight

var animation_manager

var globals
# ----------------------------------


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = $Camera

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
#	if is_dead:
#		return
		
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * 1))
#		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
#
#		var camera_rot = rotation_helper.rotation_degrees
#		camera_rot.x = clamp(camera_rot.x, -70, 70)
#		rotation_helper.rotation_degrees = camera_rot

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_object_local(Vector3(0, 1, 0), event.relative.x * MOUSE_SENSITIVITY)
#		camera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
#		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * 1))
#		self.rotate_y(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		
#		var camera_rot = rotation_helper.rotation_degrees
#		camera_rot.x = clamp(camera_rot.x, -70, 70)
#		rotation_helper.rotation_degrees = camera_rot

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("change_camera"):
			get_viewport().get_camera().clear_current();
