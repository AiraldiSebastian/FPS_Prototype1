extends KinematicBody

# ----------------------------------
# Physics
export var GRAVITY: int

# Kinematic
export var MAX_SPEED:		int
export var ACCEL:			int
export var MAX_SLOPE_ANGLE:	int
var playerVel = Vector3()
var playerDir = Vector3()
var animationDir: Vector3
var is_sprinting: bool = false
# ----------------------------------


# ----------------------------------
# Health
export var MAX_HEALTH: int
# ----------------------------------


# ----------------------------------
# Others


# Rotation related
var rot_horiz = 0
var rot_verti = 0

# For debugging
var counterFrames = 0
var counterFrames2 = 0
var counterFrames3 = 0
var counterFrames4 = 0
var counterFrames5 = 0

# Variables based on nodes
var animationPlayer: AnimationPlayer
var audioPlayer: AudioStreamPlayer
var camera: Camera
var rayCast: RayCast
var skel: Skeleton
var UI_GunLabel: Label

# Variables based on scripts
var healthSystem: HealthSystem

# Mouse
var MOUSE_SENSITIVITY:float = 0.005
var mouse_scroll_value:int = 0
const MOUSE_SENSITIVITY_SCROLL_WHEEL:float = 0.08

# Weapon related
var weaponNode
var playerCurrentWeapon: WeaponSystem
var isPlayerArmed: bool
var weaponsList = {}

var scene_AssaultRifle_A =	preload("res://scenes/Weapons/FireWeapons/AssaultRifle_A.tscn")
var scene_Shotgun =			preload("res://scenes/Weapons/FireWeapons/Shotgun.tscn")
# ----------------------------------


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Getters Node based
	camera = $Camera
	skel = $Armature/Skeleton
	animationPlayer = $Systems/AnimationSystem/AnimationPlayer
	audioPlayer = $Systems/AudioSystem/AudioStreamPlayer
	rayCast = $Systems/WeaponSystem/RayCast
	UI_GunLabel = $HUD/Panel/Gun_label
	weaponNode = $Systems/WeaponSystem
	
	# Getters Script based
	healthSystem = load("res://scripts/HealthSystem.gd").new(MAX_HEALTH, MAX_HEALTH)
	
	
	# Others
	isPlayerArmed = true
	
	
	# Setters
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.translation = skel.get_bone_global_pose(skel.find_bone("head")).origin
	rayCast.transform = camera.transform
	rayCast.cast_to = Vector3(0, 0, -20)
	
	# Set weapons
	weaponsList["AssaultRifle_A"] = scene_AssaultRifle_A.instance()
	weaponsList["Shotgun"] = scene_Shotgun.instance()
	
	weaponsList["AssaultRifle_A"].set_visible(false)
	weaponsList["Shotgun"].set_visible(false)
	
	weaponNode.add_child(weaponsList["AssaultRifle_A"])
	weaponNode.add_child(weaponsList["Shotgun"])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process():
#	pass


func _physics_process(delta):
	
	# Processes
	process_input(delta)
#	process_view_input(delta)
	process_movement(delta)
	process_animation(delta)
		
#	if (grabbed_object == null):
#		process_changing_weapons(delta)
#		process_reloading(delta)

	process_UI(delta)
#	process_respawn(delta)
	


func process_UI(_delta):
	if playerCurrentWeapon:
		UI_GunLabel.text = "HEALTH: " + str(healthSystem.get_health()) + \
				"\nAMMO: " + str(playerCurrentWeapon.get_current_ammo()) + "/" + str(playerCurrentWeapon.get_max_ammo())
	else:
		UI_GunLabel.text = "HEALTH: " + str(healthSystem.get_health())


func process_input(_delta):
	if Input.is_action_just_pressed("fire"):
		if playerCurrentWeapon:
			playerCurrentWeapon.fire(camera, get_world().direct_space_state, audioPlayer)


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
	
	playerVel = playerVel.linear_interpolate(playerDir * MAX_SPEED, delta * ACCEL)
	
	if playerVel.length() > MAX_SPEED:
		playerVel = playerVel.normalized() * MAX_SPEED
		
	if !is_on_floor():
		playerVel.y = -GRAVITY
		animationDir.y = -1
	
	move_and_slide_with_snap(playerVel, Vector3(0, -0.1, 0), Vector3.UP, true, 1, deg2rad(60), true)
	# ----------------------------------------------------------------------------------------------	


func process_animation(_delta):
#	Currently when player falls animation will not play, since Vectors have the Y-Axis set to 0
#	and when player falls Y-Axis is set to -1. We could set to test both cases if we want 
#	animations to keep playing whe player is fallin.
#
#	Method 1
#	------------------------------------------------------------------------------------------------
	if playerCurrentWeapon:
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
		
		# Method 1
		# ------------------------------------------------------------------------------------------
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
		
		rayCast.transform = camera.transform
		
		# Rotate arms and head on X-Axis (Vertically) as well
#		var headBoneIndex = skel.find_bone("head")
#		var headBoneTransform = skel.get_bone_custom_pose(headBoneIndex)
#
#		skel.set_bone_pose(headBoneIndex, headBoneTransform.rotated(Vector3(1, 0, 0), rot_verti))
		# ------------------------------------------------------------------------------------------
		
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
		if event.is_action_pressed("key_1"):
			if playerCurrentWeapon:
				playerCurrentWeapon.set_visible(false)
			playerCurrentWeapon = null
		if event.is_action_pressed("key_2"):
			change_weapon("AssaultRifle_A")
		if event.is_action_pressed("key_3"):
			change_weapon("Shotgun")
		if event.is_action_pressed("reload"):
			if playerCurrentWeapon:
				playerCurrentWeapon.reload(audioPlayer)

func change_weapon(var weaponName: String):
	if playerCurrentWeapon:
		playerCurrentWeapon.set_visible(false)
	playerCurrentWeapon = weaponsList[weaponName].equip(audioPlayer)
	playerCurrentWeapon.set_visible(true)
