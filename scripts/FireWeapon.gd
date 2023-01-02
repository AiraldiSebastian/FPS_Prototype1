class_name FireWeapon extends Item


# Export member variables
#-------------------------------------------------------------------------------
@export var DAMAGE: int            : get = get_damage
@export var MAX_AMMO: int          : get = get_max_ammo
@export var MAG_MAX_AMMO: int      : get = get_mag_max_ammo
@export var current_ammo: int      : get = get_current_ammo
@export var current_mag_ammo: int  : get = get_current_mag_ammo
@export var RANGE: int             : get = get_range
@export var FIRE_RATE: float       : get = get_fire_rate
@export var RELOAD_TIME: float     : get = get_reload_time

@export var ANIMATION_RELOAD: Animation  : get = get_animation_reload
@export var ANIMATION_FIRE: Animation    : get = get_animation_fire
@export var AUDIO_FIRE: AudioStream      : get = get_audio_fire
@export var AUDIO_RELOAD: AudioStream    : get = get_audio_reload
@export var AUDIO_EMPTY: AudioStream     : get = get_audio_empty
#-------------------------------------------------------------------------------


# Member variables
#-------------------------------------------------------------------------------
var raycast: RayCast3D : get = get_raycast, set = set_raycast
#-------------------------------------------------------------------------------


# Enums
#-------------------------------------------------------------------------------
enum WeaponState {
	EMPTY,
	NOT_FULL,
	FULL,
}


enum {
	RELOAD = Item.UNEQUIP + 1,
	EMPTY
}
#-------------------------------------------------------------------------------


# Constructors/Initializers
#-------------------------------------------------------------------------------
func _init(audioPlayerPath = null):
	super(audioPlayerPath)
	pass
#-------------------------------------------------------------------------------


# Getters
#-------------------------------------------------------------------------------
func get_class():
	return "Medkit"


func get_damage():
	return DAMAGE


func get_max_ammo():
	return MAX_AMMO


func get_mag_max_ammo():
	return MAG_MAX_AMMO


func get_current_ammo():
	return current_ammo


func get_current_mag_ammo():
	return current_mag_ammo


func get_range():
	return RANGE


func get_fire_rate():
	return FIRE_RATE


func get_reload_time():
	return RELOAD_TIME


func get_animation(animationName):
	var retAnim = super.get_animation(animationName)
	if !retAnim:
		match animationName:
			RELOAD:
				return get_animation_reload()
			EMPTY:
				return get_animation_equip()
			_:
				return null
	else:
		return retAnim


func get_animation_reload():
	return ANIMATION_RELOAD


func get_animation_fire():
	return ANIMATION_FIRE


func get_animation_use():
	return get_animation_fire()


func get_audio_use():
	return get_audio_fire()


func get_audio_fire():
	return AUDIO_FIRE


func get_audio_reload():
	return AUDIO_RELOAD


func get_audio_empty():
	return AUDIO_EMPTY


func get_weapon_state():
	if current_mag_ammo == MAG_MAX_AMMO:
		return WeaponState.FULL
	elif current_ammo == 0:
		return WeaponState.EMPTY
	else:
		return WeaponState.NOT_FULL


func get_raycast():
	return raycast
#-------------------------------------------------------------------------------


# Setters
#-------------------------------------------------------------------------------
func set_fire_audio():
	if AUDIO_PLAYER_PATH != null and ANIMATION_FIRE and AUDIO_FIRE:
		pass
#		var track_idx = ANIMATION_FIRE.add_track(Animation.TYPE_AUDIO)
#		ANIMATION_FIRE.track_set_path(track_idx, AUDIO_PLAYER_PATH)
#
#		# warning-ignore:return_value_discarded
#		ANIMATION_FIRE.audio_track_insert_key(track_idx, 0, AUDIO_FIRE)


func set_raycast(argRaycast: RayCast3D):
	raycast = argRaycast
#	raycast.cast_to = Vector3(0, 0, -get_range())
	raycast.set_target_position(Vector3(0, 0, -get_range()))
#-------------------------------------------------------------------------------


# Class related methods
#-------------------------------------------------------------------------------
func use():
	return fire()


func pick(audioPlayerPath = null):
	super.pick(audioPlayerPath)
	set_fire_audio()
	return self


func fire():
	if current_mag_ammo == 0:
		return false
	
	current_mag_ammo -= 1
	var collider = raycast.get_collider()
	if collider:
		# This should be changed
		#-----------------------------------------------------------------------
		if "healthSystem" in collider:
			collider.healthSystem.take_damage(DAMAGE)
		#-----------------------------------------------------------------------
	return true


func add_ammo(ammo: int):
	if ammo:
		current_ammo += ammo


func reload_gun():
	if current_mag_ammo == MAG_MAX_AMMO:
		return WeaponState.FULL
	if current_ammo == 0:
		return WeaponState.EMPTY
	
	var reload_ammo_needed = MAG_MAX_AMMO - current_mag_ammo
	
	if current_ammo >= reload_ammo_needed:
		current_ammo -= reload_ammo_needed
	else:
		reload_ammo_needed = current_ammo
		current_ammo = 0
	
	current_mag_ammo += reload_ammo_needed


func clone():
	var _clone = load(get_scene_file_path()).instantiate()
	_clone.current_mag_ammo = current_mag_ammo
	_clone.current_ammo = current_ammo
	return _clone
#-------------------------------------------------------------------------------
