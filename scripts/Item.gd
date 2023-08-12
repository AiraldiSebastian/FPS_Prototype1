class_name Item extends RigidBody3D


# Export member variables.
#-------------------------------------------------------------------------------
@export var NAME: String              : get = get_name
@export var ICON: CompressedTexture2D : get = get_icon
# Its twin for using with the perspective-character.
@export var twinItemResource: Resource

@export var COLLISION_LAYERS: Array : get = get_collision_layers
@export var COLLISION_MASKS: Array  : get = get_collision_masks

@export var HAND_POSITION: Vector3  : get = get_hand_position

@export var ANIMATION_USE: Animation     : get = get_animation_use
@export var AUDIO_USE: AudioStream       : get = get_audio_use
@export var ANIMATION_EQUIP: Animation   : get = get_animation_equip
@export var AUDIO_EQUIP: AudioStream     : get = get_audio_equip
@export var ANIMATION_UNEQUIP: Animation : get = get_animation_unequip
@export var AUDIO_UNEQUIP: AudioStream   : get = get_audio_unequip
#-------------------------------------------------------------------------------


# Member variables.
#-------------------------------------------------------------------------------
var AUDIO_PLAYER_PATH: String : get = get_audio_player_path

# itemOwner instead of owner to not clash with Node.owner var.
var itemOwner : get = get_item_owner

# Its twin for using with the perspective-character.
var twinItem: Item : get = get_twin_item
#-------------------------------------------------------------------------------


# Animation States.
#-------------------------------------------------------------------------------
enum {
	USE,
	EQUIP,
	UNEQUIP
}
#-------------------------------------------------------------------------------

# Constructors/Initializers.
#-------------------------------------------------------------------------------
func _init(p_audioPlayerPath = null):
	if p_audioPlayerPath:
		AUDIO_PLAYER_PATH = p_audioPlayerPath

func _ready():
	if twinItemResource:
		twinItem = twinItemResource.instantiate()
	pass
#-------------------------------------------------------------------------------


# Getters.
#-------------------------------------------------------------------------------
func get_class():
	return "Item"


func get_name():
	return NAME


func get_icon():
	return ICON


func get_collision_layers():
	return COLLISION_LAYERS


func get_collision_masks():
	return COLLISION_MASKS


func get_hand_position():
	return HAND_POSITION


func get_animation(p_animationName):
	match p_animationName:
		USE:
			return get_animation_use()
		EQUIP:
			return get_animation_equip()
		UNEQUIP:
			return get_animation_unequip()
		_:
			return null


# The derived items from this class, should always implement this method!
func get_animation_use(): # Pure virtual
	pass

func get_audio_use():
	return AUDIO_USE


func get_animation_equip():
	return ANIMATION_EQUIP


func get_audio_equip():
	return AUDIO_EQUIP


func get_animation_unequip():
	return ANIMATION_UNEQUIP


func get_audio_unequip():
	return AUDIO_UNEQUIP


func get_audio_player_path():
	return AUDIO_PLAYER_PATH


func get_item_mesh():
	# This should definitely be updated. Returning the first children
	# is a very bad way of implementing this function...
	return get_child(0)

func get_item_owner():
	return itemOwner

func get_twin_item():
	return twinItem
#-------------------------------------------------------------------------------


# Setters.
#-------------------------------------------------------------------------------
func set_equip_audio():
	if AUDIO_PLAYER_PATH != null and ANIMATION_EQUIP and AUDIO_EQUIP:
		var track_idx = ANIMATION_EQUIP.add_track(Animation.TYPE_AUDIO)
		ANIMATION_EQUIP.track_set_path(track_idx, AUDIO_PLAYER_PATH)

		# warning-ignore:return_value_discarded
		ANIMATION_EQUIP.audio_track_insert_key(track_idx, 0, AUDIO_EQUIP)

func set_item_owner(p_owner):
	itemOwner = p_owner
	
#-------------------------------------------------------------------------------


# Class related methods.
#-------------------------------------------------------------------------------
# Not sure if these methods should actually exist... An item can be picked but
# a method should reflect a verb that the object executes. The player picks, 
# drops and equips the item. The item does not execute these actions,
# the player does... 
func pick(p_audioPlayerPath = null):
	if get_parent():
		get_parent().remove_child(self)
	
	if p_audioPlayerPath:
		AUDIO_PLAYER_PATH = p_audioPlayerPath
	set_equip_audio()
	
	return self


func drop(): # Pure Virtual
	pass


func equip(): # Pure Virtual
	return self


func use(): # Pure Virtual
	pass


func clone():
	return load(get_scene_file_path()).instantiate()
#-------------------------------------------------------------------------------


# Collision related.
# ------------------------------------------------------------------------------
func set_initial_layers():
	for index in COLLISION_LAYERS.size():
		set_collision_layer_value(COLLISION_LAYERS[index], true)


func set_initial_masks():
	for index in COLLISION_MASKS.size():
		set_collision_mask_value(COLLISION_MASKS[index], true)


func clear_all_layers():
	for index in 31:
		set_collision_layer_value(index + 1, false)


func clear_all_masks():
	for index in 31:
		set_collision_mask_value(index + 1, false)
# ------------------------------------------------------------------------------
