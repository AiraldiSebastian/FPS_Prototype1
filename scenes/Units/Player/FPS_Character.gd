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
var playerDir = Vector3()
var is_sprinting : bool = false
# ----------------------------------

# ----------------------------------
# Others

var isPlayerArmed: bool

const MAX_SLOPE_ANGLE = 45

var rot_horiz = 0
var rot_verti = 0

# For debugging
var counterFrames = 0
var counterFrames2 = 0
var counterFrames3 = 0
var counterFrames4 = 0
var counterFrames5 = 0

# Variables based on nodes
var camera: Camera
var camera2: Camera
var skel
var audioPlayer: AudioStreamPlayer
var animationPlayer: AnimationPlayer
var animationDir

# Mouse
var MOUSE_SENSITIVITY = 0.005
var mouse_scroll_value = 0
const MOUSE_SENSITIVITY_SCROLL_WHEEL = 0.08

var playerWeapon

var rayCast
var rayCast2

var flashlight

var globals
# ----------------------------------


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Getters
	camera = $Camera
	camera2 = $Camera2
	skel = $Armature/Skeleton
	animationPlayer = $AnimationPlayer
	audioPlayer = $AudioStreamPlayer
	rayCast = $Weapons/RayCast
	rayCast2 = $RayCast2
	isPlayerArmed = true
	
	
	# Setters
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.translation = skel.get_bone_global_pose(skel.find_bone("head")).origin
	rayCast.transform = camera.transform
	rayCast.cast_to = Vector3(0, 0, -20)
	rayCast2.transform = camera.transform
	rayCast2.cast_to = Vector3(10, 0, 0)
	playerWeapon = load("res://scenes/Units/Player/Weapons.gd").new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process():
#	pass

func _physics_process(delta):
	process_input(delta)
#	process_view_input(delta)
	process_movement(delta)
	process_animation(animationDir)
		
#	if (grabbed_object == null):
#		process_changing_weapons(delta)
#		process_reloading(delta)

#	process_UI(delta)
#	process_respawn(delta)
	

func process_input(delta):
	if Input.is_action_just_pressed("fire"):
#		print("RayCast ")
		playerWeapon.fire_weapon(self, camera, camera2, rayCast2, get_world().direct_space_state)
		audioPlayer.set_stream(load("res://assets/sounds/ak47-1.wav"))
		audioPlayer.set_volume_db(-30.0)
		audioPlayer.play()

func process_movement(delta):
	
	# Method 1
	# ----------------------------------------------------------------------------------------------
	animationDir = Vector3()	
	playerDir = Vector3()
	
	if Input.is_action_pressed("movement_forward"):
		playerDir += transform.basis.z
		animationDir.z += 1
	if Input.is_action_pressed("movement_backward"):
		playerDir -= transform.basis.z
		animationDir.z -= 1
	if Input.is_action_pressed("movement_left"):
		playerDir += transform.basis.x
		animationDir.x += 1
	if Input.is_action_pressed("movement_right"):
		playerDir -= transform.basis.x
		animationDir.x -= 1

	playerDir = playerDir.normalized()
	
	vel = vel.linear_interpolate(playerDir * MAX_SPEED, delta * 10)
	
	if vel.length() > MAX_SPEED:
		vel = vel.normalized() * MAX_SPEED
		
	if !is_on_floor():
		vel.y = -GRAVITY
		animationDir.y = -1
	
	move_and_slide_with_snap(vel, Vector3(0, -0.1, 0), Vector3.UP, true, 1, deg2rad(60), true)
	# ----------------------------------------------------------------------------------------------	


func process_animation(animationDir):
		
#	Method 1
#	------------------------------------------------------------------------------------------------
#	Currently when player falls animation will not play, since Vectors have the Y-Axis set to 0
#	and when player falls Y-Axis is set to -1. We could set to test both cases if we want 
#	animations to keep playing whe player is fallin.
#
#	if animationDir == Vector3(0, 0, 0) or animationDir == Vector3(0, -1, 0):
#		animationPlayer.play("unarmed_idle", 0.1)
#	if animationDir == Vector3(1, 0, 1):
#		animationPlayer.play("unarmed_left", 0.1)
#	if animationDir == Vector3(-1, 0, 1):
#		animationPlayer.play("unarmed_right", 0.1)
#	if animationDir == Vector3(1, 0, -1):
#		animationPlayer.play("unarmed_right", 0.1)
#	if animationDir == Vector3(-1, 0, -1):
#		animationPlayer.play("unarmed_left", 0.1)
#	if animationDir == Vector3(0, 0, 1):
#		animationPlayer.play("unarmed_forward", 0.1)
#	if animationDir == Vector3(0, 0, -1):
#		animationPlayer.play("unarmed_backwards", 0.1)
#	if animationDir == Vector3(1, 0, 0):
#		animationPlayer.play("unarmed_left", 0.1)
#	if animationDir == Vector3(-1, 0, 0):
#		animationPlayer.play("unarmed_right", 0.1)
#	------------------------------------------------------------------------------------------------
	
#	Method 2
#	------------------------------------------------------------------------------------------------
	if isPlayerArmed:
		if animationDir == Vector3(0, 0, 0) or animationDir == Vector3(0, -1, 0):
			animationPlayer.play("armed_idle", 0.1)
		if animationDir == Vector3(1, 0, 1):
			animationPlayer.play("armed_left", 0.1)
		if animationDir == Vector3(-1, 0, 1):
			animationPlayer.play("armed_right", 0.1)
		if animationDir == Vector3(1, 0, -1):
			animationPlayer.play("armed_right", 0.1)
		if animationDir == Vector3(-1, 0, -1):
			animationPlayer.play("armed_left", 0.1)
		if animationDir == Vector3(0, 0, 1):
			animationPlayer.play("armed_forward", 0.1)
		if animationDir == Vector3(0, 0, -1):
			animationPlayer.play("armed_backwards", 0.1)
		if animationDir == Vector3(1, 0, 0):
			animationPlayer.play("armed_left", 0.1)
		if animationDir == Vector3(-1, 0, 0):
			animationPlayer.play("armed_right", 0.1)
	else:
		if animationDir == Vector3(0, 0, 0) or animationDir == Vector3(0, -1, 0):
			animationPlayer.play("unarmed_idle", 0.1)
		if animationDir == Vector3(1, 0, 1):
			animationPlayer.play("unarmed_left", 0.1)
		if animationDir == Vector3(-1, 0, 1):
			animationPlayer.play("unarmed_right", 0.1)
		if animationDir == Vector3(1, 0, -1):
			animationPlayer.play("unarmed_right", 0.1)
		if animationDir == Vector3(-1, 0, -1):
			animationPlayer.play("unarmed_left", 0.1)
		if animationDir == Vector3(0, 0, 1):
			animationPlayer.play("unarmed_forward", 0.1)
		if animationDir == Vector3(0, 0, -1):
			animationPlayer.play("unarmed_backwards", 0.1)
		if animationDir == Vector3(1, 0, 0):
			animationPlayer.play("unarmed_left", 0.1)
		if animationDir == Vector3(-1, 0, 0):
			animationPlayer.play("unarmed_right", 0.1)
#	------------------------------------------------------------------------------------------------

func _input(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		counterFrames2 += 1
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
		
#		rayCast.transform = camera.transform
		
		# Rotate arms and head on X-Axis (Vertically) as well
#		var headBoneIndex = skel.find_bone("head")
#		var headBoneTransform = skel.get_bone_custom_pose(headBoneIndex)
#
#		skel.set_bone_pose(headBoneIndex, headBoneTransform.rotated(Vector3(1, 0, 0), rot_verti))
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
