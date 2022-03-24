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

var rot_horiz = 0
var rot_verti = 0

var counterFrames = 0

var camera
var rotation_helper
var skel

# Mouse
var MOUSE_SENSITIVITY = 0.005
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
	skel = $Armature/Skeleton
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process():
#	pass

func _physics_process(delta):
#	process_input(delta)
#	process_view_input(delta)
	process_movement(delta)
		
#	if (grabbed_object == null):
#		process_changing_weapons(delta)
#		process_reloading(delta)

#	process_UI(delta)
#	process_respawn(delta)
	

func process_movement(delta):
	
	# Method 1
	# ----------------------------------------------------------------------------------------------
	dir = Vector3()
	if Input.is_action_pressed("movement_forward"):
		dir += transform.basis.z
	if Input.is_action_pressed("movement_backward"):
		dir -= transform.basis.z
	if Input.is_action_pressed("movement_left"):
		dir += transform.basis.x
	if Input.is_action_pressed("movement_right"):
		dir -= transform.basis.x
		
	dir.normalized()
	vel = vel.linear_interpolate(dir * MAX_SPEED, delta * 10)
	
	if vel.length() > MAX_SPEED:
		vel = vel.normalized() * MAX_SPEED
		
	if !is_on_floor():
		vel.y = -GRAVITY
	
	move_and_slide_with_snap(vel, Vector3(0, -0.1, 0), Vector3.UP, true, 1, deg2rad(60), true)
	# ----------------------------------------------------------------------------------------------	

func _input(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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
		
		# Method 1
		# ------------------------------------------------------------------------------------
		rot_horiz += event.relative.x * MOUSE_SENSITIVITY
		rot_verti += event.relative.y * MOUSE_SENSITIVITY
		
		# Clamp the values to the allowed degree of motion 
		rot_horiz += clamp(rot_horiz, deg2rad(0), deg2rad(360))
		rot_verti = clamp(rot_verti, deg2rad(-70), deg2rad(70))

		# Rotate on Y-Axis (Horizontally)
		transform.basis = Basis()
		rotate_object_local(Vector3(0, 1, 0), -rot_horiz)
		
		# Rotate on X-Axis (Vertically)
		camera.transform.basis = Basis()
		camera.rotate_y(deg2rad(180))		# So camera looks at same dir than character
		camera.rotate_x(rot_verti)
		# ------------------------------------------------------------------------------------
		
		# Method 2
		# ------------------------------------------------------------------------------------
#		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
#		transform.orthonormalized()

#		var rot_y_clamped = clamp(event.relative.y * MOUSE_SENSITIVITY, -70, 70)
#		camera.rotate_x(rot_y_clamped)
#		camera.transform.orthonormalized()
		# ------------------------------------------------------------------------------------		

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("change_camera"):
			get_viewport().get_camera().clear_current();
