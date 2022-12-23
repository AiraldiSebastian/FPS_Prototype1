class_name Character extends KinematicBody


# Member variables
#-------------------------------------------------------------------------------
# Movement related
# ----------------------------------
# Physics
export var GRAVITY: int

# Kinematic
export var MAX_SPEED: int
export var ACCEL:     int
export var MAX_SLOPE_ANGLE: int

var playerVel: Vector3
var playerDir: Vector3
var animationDir: Vector3

var is_sprinting: bool
# ----------------------------------


# Health related
# ----------------------------------
# Health
var healthSystem: HealthSystem

export var MAX_HEALTH:   int
export var START_HEALTH: int
# ----------------------------------


# Camera control
# ----------------------------------
# Rotation holder
var rot_horiz: float
var rot_verti: float

# Camera and Skeleton nodes
var perspCamera: Camera
var skel: Skeleton
var perspSkel: Skeleton
# ----------------------------------


# Animation & Audio
# ----------------------------------
var characterAnim: AnimationPlayer
var perspectiveAnim: AnimationPlayer
var charMoveState: AnimationTree
var audioPlayer: AudioStreamPlayer
var audioPlayerContinuous: AudioStreamPlayer
# ----------------------------------


# Player State
# ----------------------------------
var playerState: BaseState
# ----------------------------------


# Weapons
# ----------------------------------
var playerCurrentItem
var perspCurrentItem
var weaponRaycast: RayCast

var handRight: BoneAttachment
var perspHandRight: BoneAttachment
# ----------------------------------


# Interaction
# ----------------------------------
var handRaycast: RayCast
# ----------------------------------


# User Interface
# ----------------------------------
var UI_HUD: Control
var UI_InfoLabel: Label
var UI_Inventory: Inventory
var UI_Hotbar: Inventory
var UI_HotbarMarker: HotbarMarker
# ----------------------------------


# Others
# ----------------------------------
# For debugging
var counterFrames:  int = 0
var counterFrames2: int = 0
var counterFrames3: int = 0
var counterFrames4: int = 0
var counterFrames5: int = 0

# Mouse
var MOUSE_SENSITIVITY: float
# ----------------------------------
#-------------------------------------------------------------------------------


# Constructors/Initializers
#-------------------------------------------------------------------------------
func _ready():
	
	# Movement related
	# ----------------------------------
	playerVel		= Vector3()
	playerDir		= Vector3()
	animationDir	= Vector3()

	is_sprinting	= false
	# ----------------------------------


	# Health related
	# ----------------------------------
	healthSystem = HealthSystem.new(MAX_HEALTH, START_HEALTH)
	# ----------------------------------


	# Camera control
	# ----------------------------------
	# Rotation holder
	rot_horiz = 0
	rot_verti = 0

	# Camera and Skeleton nodes
	perspCamera		= $Perspective/Armature/Skeleton/CameraAttachment/Camera
	skel			= $Armature/Skeleton
	perspSkel		= $Perspective/Armature/Skeleton
	# ----------------------------------


	# Animation & Audio
	# ----------------------------------
	characterAnim	= $CharacterAnimation
	perspectiveAnim	= $Perspective/PerspectiveAnimation
	charMoveState	= $AnimationTree
	charMoveState.set_active(true)
	audioPlayer	= $AudioStreamPlayer
	audioPlayerContinuous = $AudioManager
	playerState		= UnequipItemState.new(self, audioPlayer, audioPlayerContinuous)
	playerState.play_state()
	# ----------------------------------


	# Weapons
	# ----------------------------------
	playerCurrentItem	= null
	perspCurrentItem	= null
	
	handRight		= $Armature/Skeleton/RightHand
	perspHandRight	= $Perspective/Armature/Skeleton/RightHand
	
	weaponRaycast	= $Perspective/Armature/Skeleton/CameraAttachment/Camera/WeaponRaycast
	weaponRaycast.set_collision_mask_bit(12, true)
	# ----------------------------------


	# Interaction
	# ----------------------------------
	handRaycast		= $Perspective/Armature/Skeleton/CameraAttachment/Camera/HandRaycast
	
	handRaycast.set_cast_to(Vector3(0, 0, -4))
	handRaycast.set_collision_mask_bit(4, true)
	# ----------------------------------


	# User Interface
	# ----------------------------------
	UI_HUD			= $HUD
	UI_InfoLabel	= $HUD/Panel/Info_Label
	UI_Inventory	= $HUD/Inventory/Inventory
	UI_Hotbar		= $HUD/Inventory/Hotbar
	UI_HotbarMarker = HotbarMarker.new(UI_Hotbar)
	
	# warning-ignore:return_value_discarded
	UI_HUD.connect("drop_item", self, "hud_event")
	# warning-ignore:return_value_discarded
	UI_HotbarMarker.connect("itemChanged", self, "hotbar_event")
	# ----------------------------------


	# Mouse
	# ----------------------------------
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	MOUSE_SENSITIVITY	= 0.005
	# ----------------------------------
	
	
	# warning-ignore:return_value_discarded
	characterAnim.connect("animation_started", self, "print_animation_info", ["Character"])
	
	Engine.set_target_fps(0)
#-------------------------------------------------------------------------------


# Processes related methods
#---------------------------------------------------------------------------------------------------
func _physics_process(delta):
	# Processes
	# -----------------------
	process_input(delta)
	process_ui(delta)
	process_movement(delta)
	# -----------------------


func process_input(_delta):
	if !UI_Inventory.is_visible():
		if Input.is_action_pressed("use_item") and playerCurrentItem is FireWeapon:
			# This event is exclusively emited if and only if the current item is a
			# FireWeapon, everything else is and should be handled in unhandled_input
			# --------------------------------------------------------------------------------------
			var event = InputEventAction.new()
			event.action = "use_item"
			event.pressed = true
			handle_input(event)
			# --------------------------------------------------------------------------------------


# This should maybe be implemented as a signal from the HealthSystem and Weapon to which the UI connects to
func process_ui(_delta):
	# Method 1
	# ----------------------------------------------------------------------------------------------
	if playerCurrentItem is FireWeapon:
		UI_InfoLabel.text = "HEALTH: " + str(healthSystem.get_health()) + "/" + str(healthSystem.get_MAX_HEALTH()) + \
				"\nAMMO: " + str(playerCurrentItem.get_current_mag_ammo()) + "/" + str(playerCurrentItem.get_current_ammo())
	elif playerCurrentItem is Medkit:
		UI_InfoLabel.text = "HEALTH: " + str(healthSystem.get_health()) + "/" + str(healthSystem.get_MAX_HEALTH()) + \
				"\nHealing: " + str(playerCurrentItem.get_heal_effect())
	else:
		UI_InfoLabel.text = "HEALTH: " + str(healthSystem.get_health()) + "/" + str(healthSystem.get_MAX_HEALTH())
	# ----------------------------------------------------------------------------------------------


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
	
	charMoveState.set("parameters/blend_position", Vector2(animationDir.x, animationDir.z))
	playerVel = move_and_slide_with_snap(playerVel, Vector3(0, -0.1, 0), Vector3.UP, true, 1, deg2rad(MAX_SLOPE_ANGLE), true)
	# ----------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


# Print / Info related methods
#---------------------------------------------------------------------------------------------------
func print_animation_info(animationPlaying: String, animationPlayer: String):
	if animationPlaying != "idle":
		print(animationPlayer, " is playing: \"", animationPlaying, "\"")
#---------------------------------------------------------------------------------------------------


# Event related methods
#---------------------------------------------------------------------------------------------------
func hud_event(item):
	# This is generated by an item drop on the HUD
	# --------------------------------------------------------------------------
	drop_item(item)
	# --------------------------------------------------------------------------


func hotbar_event(item):
	# This is generated by an item switch between slots
	# --------------------------------------------------------------------------
	var event = InputEventAction.new()
	event.pressed = true
	if item:
		event.action = "equip_item"
	else:
		event.action = "unequip_item"
	handle_input(event)
	# --------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


# Input related methods
#---------------------------------------------------------------------------------------------------
func handle_input(event: InputEvent):
	var new_state: BaseState = playerState.handle_input(event)
	if !(new_state is NullState):
		playerState = new_state
		new_state.play_state()
		return true
	return false


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_control(event)
	if event is InputEventKey:
		# Keynums input
		# ----------------------------------------------------------------------
		if event.is_action_pressed("key_1"):
			UI_HotbarMarker.select_slot(0)
		if event.is_action_pressed("key_2"):
			UI_HotbarMarker.select_slot(1)
		if event.is_action_pressed("key_3"):
			UI_HotbarMarker.select_slot(2)
		if event.is_action_pressed("key_4"):
			UI_HotbarMarker.select_slot(3)
		if event.is_action_pressed("key_5"):
			UI_HotbarMarker.select_slot(4)
		# ----------------------------------------------------------------------
		
		# Keyletters input
		# ----------------------------------------------------------------------
		if event.is_action_pressed("interact"):
			interact()
		if event.is_action_pressed("drop"):
			drop_item(playerCurrentItem)
		if event.is_action_pressed("inventory"):
			open_inventory()
		# ----------------------------------------------------------------------
		
		# Others
		# ----------------------------------------------------------------------
		if event.is_action_pressed("change_camera"):
			get_viewport().get_camera().clear_current();
		# ----------------------------------------------------------------------
	handle_input(event)
#---------------------------------------------------------------------------------------------------


# Camera related methods
#---------------------------------------------------------------------------------------------------
func camera_control(event):
	# Update our rotations variables in function of mouse movement
	# ----------------------------------------------------------------------------------------------
	rot_horiz += event.relative.x * MOUSE_SENSITIVITY
	rot_verti += event.relative.y * MOUSE_SENSITIVITY
	# ----------------------------------------------------------------------------------------------


	# Clamp the values to the allowed degree of motion 
	# ----------------------------------------------------------------------------------------------
	rot_horiz += clamp(rot_horiz, deg2rad(0), deg2rad(360))
	rot_verti = clamp(rot_verti, deg2rad(-70), deg2rad(70))
	# ----------------------------------------------------------------------------------------------


	# Rotate on Y-Axis (Horizontally)
	# ----------------------------------------------------------------------------------------------
	transform.basis = Basis()
	rotate_object_local(Vector3(0, 1, 0), -rot_horiz)
	# ----------------------------------------------------------------------------------------------


	# Rotate first on characters skeleton
	# ----------------------------------------------------------------------------------------------
	# Rotate Head on X-Axis (Vertically)
	var headBoneIndex = skel.find_bone("head")
	var headBoneTransform = skel.get_bone_custom_pose(headBoneIndex)
	skel.set_bone_pose(headBoneIndex, headBoneTransform.rotated(Vector3(1, 0, 0), rot_verti))
	
	# Rotate arms on X-Axis (Vertically)
	if playerCurrentItem:
		var armsIndex = skel.find_bone("arm_control")
		var armsTransform = skel.get_bone_custom_pose(armsIndex)
		skel.set_bone_pose(armsIndex, armsTransform.rotated(Vector3(1, 0, 0), rot_verti))
	# ----------------------------------------------------------------------------------------------
	
	
	# Rotate now on the perspective skeleton
	# ----------------------------------------------------------------------------------------------
	# Rotate Head on X-Axis (Vertically)
	var perspHeadBoneIndex = perspSkel.find_bone("head")
	var perspHeadBoneTransform = perspSkel.get_bone_custom_pose(perspHeadBoneIndex)
	perspSkel.set_bone_pose(perspHeadBoneIndex, perspHeadBoneTransform.rotated(Vector3(1, 0, 0), rot_verti))
	
	# Rotate arms on X-Axis (Vertically)
	if playerCurrentItem:
		var perspArmsIndex = perspSkel.find_bone("arm_control")
		var perspArmsTransform = perspSkel.get_bone_custom_pose(perspArmsIndex)
		perspSkel.set_bone_pose(perspArmsIndex, perspArmsTransform.rotated(Vector3(1, 0, 0), rot_verti))
	# ----------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------


# Inventory/Items related methods
#---------------------------------------------------------------------------------------------------
func open_inventory():
	if UI_Inventory.is_visible():
		UI_HUD.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		UI_Inventory.set_visible(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		UI_HUD.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		UI_Inventory.set_visible(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func interact():
	var object = handRaycast.get_collider()
	if object is Item:
		add_item(object)


func reload():
	if playerCurrentItem is FireWeapon:
		# Reload, in case reload() returns empty, search if an AMMO
		# Pack is available in the inventory and reload using it.
		# ------------------------------------------------------------------------------------------
		if playerCurrentItem.reload() == FireWeapon.WeaponState.EMPTY:
			var item = null
			var ammo = null
			
			# First search in Hotbar
			# --------------------------------------------------------------------------------------
			item = UI_Hotbar.get_first_item_of_type("Ammo")
			if item:
				ammo = item.use()
				if item.get_charges() == 0:
					delete_item(item)
				playerCurrentItem.add_ammo(ammo)
				perspCurrentItem.add_ammo(ammo)
				return
			# --------------------------------------------------------------------------------------
			
			# Second search in Inventory
			# --------------------------------------------------------------------------------------
			item = UI_Inventory.get_first_item_of_type("Ammo")
			if item:
				ammo = item.use()
				if item.get_charges() == 0:
					delete_item(item)
				playerCurrentItem.add_ammo(ammo)
				perspCurrentItem.add_ammo(ammo)
				return
			# --------------------------------------------------------------------------------------
	return true


func use_item(item):
	if !item:
		return false
	
	# Compare the item to the possible item classes
	# --------------------------------------------------------------------------
	if item is FireWeapon:
		# Fire Weapon
		# ----------------------------------------------------------------------
		return item.use()
		# ----------------------------------------------------------------------
	elif item is Consumable:
		# Medkit
		# ----------------------------------------------------------------------
		if item is Medkit:
			healthSystem.take_health(item.use())
			if item.get_charges() == 0:
				delete_item(item)
			return true
		# ----------------------------------------------------------------------
		
		# Ammo
		# ----------------------------------------------------------------------
		elif item is Ammo:
			pass
		# ----------------------------------------------------------------------
	# --------------------------------------------------------------------------
	
	return false


func add_item(item):
	# First try add to Hotbar
	# --------------------------------------------------------------------------
	if !UI_Hotbar.is_full():
		UI_Hotbar.add_item(item.pick(audioPlayer.get_path()))
	# --------------------------------------------------------------------------
	
	# If Hotbar full, try Inventory
	# --------------------------------------------------------------------------
	elif !UI_Inventory.is_full():
		UI_Inventory.add_item(item.pick(audioPlayer.get_path()))
	# --------------------------------------------------------------------------
	
	# Else return false (both are full)
	# --------------------------------------------------------------------------
	else:
		return false
	# --------------------------------------------------------------------------
	
	return true


func drop_item(item):
	if !item:
		return false
	
	
	# We assume the item is in the inventory
	# --------------------------------------------------------------------------
	var itemRef = UI_Hotbar.remove_item(item)
	if !itemRef:
		itemRef = UI_Inventory.remove_item(item)
	# --------------------------------------------------------------------------
	
	
	# Set where the item should spawn (players mid body for now)
	# --------------------------------------------------------------------------
	var newTransform: Transform = transform
	newTransform.origin.y += transform.origin.y / 2
	itemRef.set_global_transform(Transform.IDENTITY)
	itemRef.set_transform(newTransform)
	# --------------------------------------------------------------------------
	
	
	# Add item to the player's parent (the world for now)
	# --------------------------------------------------------------------------
	get_owner().add_child(itemRef)
	itemRef.set_sleeping(false)
	return true
	# --------------------------------------------------------------------------


func delete_item(item):
	if !item:
		return false
	
	# Delete item from inventory
	# --------------------------------------------------------------------------
	var retVal = UI_Hotbar.delete_item(item)
	if !retVal:
		retVal = UI_Inventory.delete_item(item)
	# --------------------------------------------------------------------------
	
	return retVal


func equip_items():
	# Remove current items
	# ----------------------------------------------------------------------------------------------
	remove_items()
	# ----------------------------------------------------------------------------------------------
	
	# Get the new Item
	# ----------------------------------------------------------------------------------------------
	var item = UI_HotbarMarker.get_item()
	if !item:
		return
	# ----------------------------------------------------------------------------------------------
	
	# If player did not had any item equipped, set the arm_control rotation to the heads rotation
	# ----------------------------------------------------------------------------------------------
	if !playerCurrentItem:
		synchronize_arms_to_head()
	# ----------------------------------------------------------------------------------------------
	
	# Equip the items, change type from rigid to static and turn off collisions
	# ----------------------------------------------------------------------------------------------
	playerCurrentItem = item.equip()
	perspCurrentItem = playerCurrentItem.clone()
	adapt_item_static(playerCurrentItem)
	adapt_item_static(perspCurrentItem)
	# ----------------------------------------------------------------------------------------------

	# Make the characters item mesh invisible for our camera perspective 8, 10 | 6, 7, 9
	# ----------------------------------------------------------------------------------------------
	adapt_item_invisibility(playerCurrentItem, perspCurrentItem)	
	# ----------------------------------------------------------------------------------------------
	
	
	# Add the items to the hands
	# ----------------------------------------------------------------------------------------------
	handRight.add_child(playerCurrentItem)
	handRight.get_child(0).translate_object_local(handRight.get_child(0).get_hand_position())
	perspHandRight.add_child(perspCurrentItem)
	perspHandRight.get_child(0).translate_object_local(perspHandRight.get_child(0).get_hand_position())
	# ----------------------------------------------------------------------------------------------
	
	
	# If the item is a fire weapon, adjust the weaponsRaycast to the weapons range
	# ----------------------------------------------------------------------------------------------
	if item is FireWeapon:
		item.set_raycast(weaponRaycast)
	# ----------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func unequip_items():
	remove_items()
	reset_arms()


func remove_items():
	if !playerCurrentItem:
		return 


	# Remove characters weapon and delete the perspective weapon
	# ----------------------------------------------------------------------------------------------
	handRight.remove_child(playerCurrentItem)
	
	var perspItem = perspHandRight.get_child(0)
	perspHandRight.remove_child(perspItem)
	perspItem.queue_free()
	# ----------------------------------------------------------------------------------------------
	
	
	# Set the initial collision layers and masks for the characters weapon
	# Only for the characters weapon, since the perspective one will be deleted
	# ----------------------------------------------------------------------------------------------
	playerCurrentItem.set_mode(RigidBody.MODE_RIGID)
	playerCurrentItem.set_initial_layers()
	playerCurrentItem.set_initial_masks()
	# ----------------------------------------------------------------------------------------------
	
	
	# Reset the layer mask bits from the characters weapon mesh
	# ----------------------------------------------------------------------------------------------
	var weaponMesh = playerCurrentItem.get_item_mesh()
	weaponMesh.set_layer_mask_bit(4, true)
	weaponMesh.set_layer_mask_bit(5, false)
	# ----------------------------------------------------------------------------------------------
	
	
	# Set the current items to null
	# ----------------------------------------------------------------------------------------------
	playerCurrentItem = null
	perspCurrentItem = null
	weaponRaycast.cast_to = Vector3(0, 0, 0)
	# ----------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

# Helper methods
#---------------------------------------------------------------------------------------------------
func reset_arms():
	# Set the arm_control to its rest position as well as the arms
	# ----------------------------------------------------------------------------------------------
	# Rotate first on the characters skeleton
	var armsIndex = skel.find_bone("arm_control")
	skel.set_bone_pose(armsIndex, Transform.IDENTITY)
	
	# Rotate now on the perspective skeleton
	var perspArmsIndex = perspSkel.find_bone("arm_control")
	perspSkel.set_bone_pose(perspArmsIndex, Transform.IDENTITY)
	# ----------------------------------------------------------------------------------------------


func synchronize_arms_to_head():
	# Rotate first on the characters skeleton	
	var armsIndex = skel.find_bone("arm_control")
	var armsTransform = skel.get_bone_custom_pose(armsIndex)
	skel.set_bone_pose(armsIndex, armsTransform.rotated(Vector3(1, 0, 0), rot_verti))

	# Rotate now on the perspective skeleton
	var perspArmsIndex = perspSkel.find_bone("arm_control")
	var perspArmsTransform = perspSkel.get_bone_custom_pose(perspArmsIndex)
	perspSkel.set_bone_pose(perspArmsIndex, perspArmsTransform.rotated(Vector3(1, 0, 0), rot_verti))
	# ----------------------------------------------------------------------------------------------


func adapt_item_static(item):
	# Change the item type from rigid to static and turn off collisions
	# ----------------------------------------------------------------------------------------------
	item.set_mode(RigidBody.MODE_STATIC)
	item.clear_all_layers()
	item.clear_all_masks()
	item.set_identity()
	# ----------------------------------------------------------------------------------------------


func adapt_item_invisibility(argPlayerCurrentItem, argPerspCurrentItem):
	# Make the characters item mesh invisible for our camera perspective 8, 10 | 6, 7, 9
	# ----------------------------------------------------------------------------------------------
	var itemMesh = argPlayerCurrentItem.get_item_mesh()
	itemMesh.set_layer_mask_bit(4, false)
	itemMesh.set_layer_mask_bit(5, true)
	
	itemMesh = argPerspCurrentItem.get_item_mesh()
	itemMesh.set_layer_mask_bit(4, false)
	itemMesh.set_layer_mask_bit(7, true)
	# ----------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------
