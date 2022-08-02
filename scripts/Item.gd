class_name Item extends RigidBody


# Export member variables
#-------------------------------------------------------------------------------
export var NAME: String        setget ,get_name
export var ICON: StreamTexture setget ,get_icon

export var COLLISION_LAYERS: Array setget ,get_collision_layers
export var COLLISION_MASKS: Array  setget ,get_collision_masks

export var HAND_POSITION: Vector3  setget ,get_hand_position

export var ANIMATION_USE: Animation     setget ,get_animation_use
export var AUDIO_USE: AudioStream       setget ,get_audio_use
export var ANIMATION_EQUIP: Animation   setget ,get_animation_equip
export var AUDIO_EQUIP: AudioStream     setget ,get_audio_equip
export var ANIMATION_UNEQUIP: Animation setget ,get_animation_unequip
export var AUDIO_UNEQUIP: AudioStream   setget ,get_audio_unequip
#-------------------------------------------------------------------------------


# Member variables
#-------------------------------------------------------------------------------
var AUDIO_PLAYER_PATH: String setget ,get_audio_player_path
#-------------------------------------------------------------------------------


enum {
	USE,
	EQUIP,
	UNEQUIP
}


# Constructors/Initializers
#-------------------------------------------------------------------------------
func _init(audioPlayerPath = null):
	if audioPlayerPath:
		AUDIO_PLAYER_PATH = audioPlayerPath


func _ready():
	set_equip_audio()
#-------------------------------------------------------------------------------


# Getters
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


func get_animation(animationName):
	match animationName:
		USE:
			return get_animation_use()
		EQUIP:
			return get_animation_equip()
		UNEQUIP:
			return get_animation_unequip()
		_:
			return null


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
	return get_child(0)


# The derived items from this class, should always implement this method!
func get_animation_use(): # Pure virtual
	pass
#-------------------------------------------------------------------------------


# Setters
#-------------------------------------------------------------------------------
func set_equip_audio():
	if AUDIO_PLAYER_PATH and ANIMATION_EQUIP and AUDIO_EQUIP:
		var track_idx = ANIMATION_EQUIP.add_track(Animation.TYPE_AUDIO)
		ANIMATION_EQUIP.track_set_path(track_idx, AUDIO_PLAYER_PATH)
		
		# warning-ignore:return_value_discarded
		ANIMATION_EQUIP.audio_track_insert_key(track_idx, 0, AUDIO_EQUIP)
#-------------------------------------------------------------------------------


# Class related methods
#-------------------------------------------------------------------------------
func pick(audioPlayerPath = null):
	if get_parent():
		get_parent().remove_child(self)
	
	if audioPlayerPath:
		AUDIO_PLAYER_PATH = audioPlayerPath
	set_equip_audio()
	
	return self

func drop(): # Pure Virtual
	pass


func equip(): # Pure Virtual
	return self


func use(): # Pure Virtual
	pass


func clone():
	return load(get_filename()).instance()
#-------------------------------------------------------------------------------


# Collision related
# ------------------------------------------------------------------------------
func set_initial_layers():
	for index in COLLISION_LAYERS.size():
		set_collision_layer_bit(COLLISION_LAYERS[index] - 1, true)


func set_initial_masks():
	for index in COLLISION_MASKS.size():
		set_collision_mask_bit(COLLISION_MASKS[index] - 1, true)


func clear_all_layers():
	for index in 31:
		set_collision_layer_bit(index, false)


func clear_all_masks():
	for index in 31:
		set_collision_mask_bit(index, false)
# ------------------------------------------------------------------------------
