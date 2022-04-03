class_name FPS_Character extends KinematicBody

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
var handsRaycast: RayCast
var weaponRaycast: RayCast
var skel: Skeleton
var UI_HUD: Control
var UI_GunLabel: Label
var UI_Inventory: Inventory
var UI_Hotbar: Hotbar
var Class_HotbarMarker = preload("res://scenes/InventorySystem/Hotbar/HotbarMarker.gd")
var UI_HotbarMarker: HotbarMarker

# Variables based on scripts
var healthSystem: HealthSystem

# Mouse
var MOUSE_SENSITIVITY:float = 0.005

# Weapon related
var weaponNode
var playerCurrentWeapon: WeaponSystem
# ----------------------------------


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Getters Node based
	camera = $Camera
	skel = $Armature/Skeleton
	animationPlayer = $Systems/AnimationSystem/AnimationPlayer
	audioPlayer = $Systems/AudioSystem/AudioStreamPlayer
	handsRaycast = $Camera/HandsRaycast
	weaponRaycast = $Camera/WeaponRaycast
	UI_HUD = $HUD
	UI_GunLabel = $HUD/Panel/Gun_label
	UI_Inventory = $HUD/Inventory/Inventory
	UI_Hotbar = $HUD/Inventory/Hotbar
	UI_HotbarMarker = Class_HotbarMarker.new(UI_Hotbar)
	weaponNode = $Systems/WeaponNode
	
	# Getters Script based
	healthSystem = load("res://scripts/HealthSystem.gd").new(MAX_HEALTH, MAX_HEALTH)
	
	
	# Setters
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.transform.origin = skel.get_bone_global_pose(skel.find_bone("head")).origin
	handsRaycast.cast_to = Vector3(0, 0, -4)
	handsRaycast.set_collision_mask_bit(4, true)
	print("HandsRaycast: get_collision_mask_bit: ", handsRaycast.get_collision_mask_bit(4))
	weaponRaycast.set_collision_mask_bit(12, true)
	
	# warning-ignore:return_value_discarded
	UI_HotbarMarker.connect("itemChanged", self, "change_weapon")


func _physics_process(delta):
	
	# Processes
	process_movement(delta)
	process_animation(delta)
	process_input(delta)
	
	process_UI(delta)


func process_input(_delta):
		if Input.is_action_pressed("fire") and playerCurrentWeapon:
			playerCurrentWeapon.fire(weaponRaycast)


# This should be implemented as a signal from the HealthSystem to which the UI connects to
func process_UI(_delta):
	if playerCurrentWeapon:
		UI_GunLabel.text = "HEALTH: " + str(healthSystem.get_health()) + \
				"\nAMMO: " + str(playerCurrentWeapon.get_current_mag_ammo()) + "/" + str(playerCurrentWeapon.get_current_ammo())
	else:
		UI_GunLabel.text = "HEALTH: " + str(healthSystem.get_health())


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
	
	playerVel = move_and_slide_with_snap(playerVel, Vector3(0, -0.1, 0), Vector3.UP, true, 1, deg2rad(MAX_SLOPE_ANGLE), true)
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


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_controll(event) 
#	if event is InputEventMouseButton:
#		if event.is_pressed() and playerCurrentWeapon:
#			playerCurrentWeapon.fire(weaponRaycast)
	if event is InputEventKey:
		if event.is_action_pressed("change_camera"):
			get_viewport().get_camera().clear_current();
		if event.is_action_pressed("key_1"):
#			change_weapon(UI_Hotbar.select_item(0))
			UI_HotbarMarker.select_slot(0)
		if event.is_action_pressed("key_2"):
#			change_weapon(UI_Hotbar.select_item(1))
			UI_HotbarMarker.select_slot(1)
		if event.is_action_pressed("key_3"):
#			change_weapon(UI_Hotbar.select_item(2))
			UI_HotbarMarker.select_slot(2)
		if event.is_action_pressed("key_4"):
#			change_weapon(UI_Hotbar.select_item(3))
			UI_HotbarMarker.select_slot(3)
		if event.is_action_pressed("key_5"):
#			change_weapon(UI_Hotbar.select_item(4))
			UI_HotbarMarker.select_slot(4)
		if event.is_action_pressed("reload"):
			if playerCurrentWeapon:
				playerCurrentWeapon.reload()
		if event.is_action_pressed("interact"):
			var collider = handsRaycast.get_collider()
			if collider and collider.get_parent() and collider.get_parent() is WeaponSystem:
				if !UI_Hotbar.is_full(UI_Inventory):
					UI_Hotbar.put_item(collider.get_parent().pick(), UI_Inventory)
		if event.is_action_pressed("drop"):
			UI_Hotbar.drop_item(playerCurrentWeapon, self)
		if event.is_action_pressed("inventory"):
			open_inventory()


func open_inventory():
	if UI_Inventory.is_visible():
		UI_HUD.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		UI_Inventory.set_visible(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		UI_HUD.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		UI_Inventory.set_visible(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func change_weapon(weapon: WeaponSystem):
#	Method 1
#	------------------------------------------------------------------------------------------------
	if playerCurrentWeapon:
		weaponNode.remove_child(playerCurrentWeapon)
	if weapon:
		playerCurrentWeapon = weapon.equip()
		weaponNode.add_child(playerCurrentWeapon)
		weaponRaycast.cast_to = Vector3(0, 0, -weapon.get_distance())
		playerCurrentWeapon.set_player_position(self)
	else:
		playerCurrentWeapon = null
		weaponRaycast.cast_to = Vector3(0, 0, 0)
#	------------------------------------------------------------------------------------------------


func camera_controll(event):
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

#		rayCast.transform = camera.transform

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
