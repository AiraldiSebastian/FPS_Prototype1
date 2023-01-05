class_name FireWeapon extends Item


# Export member variables
#-------------------------------------------------------------------------------
@export var DAMAGE: int            : get = get_damage
@export var MAG_MAX_AMMO: int      : get = get_mag_max_ammo
@export var current_mag_ammo: int  : get = get_current_mag_ammo
@export var RANGE: int             : get = get_range
@export var FIRE_RATE: float       : get = get_fire_rate
@export var RELOAD_TIME: float     : get = get_reload_time

@export var ANIMATION_RELOAD: Animation  : get = get_animation_reload
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


# Animation States
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
	return "FireWeapon"


func get_damage():
	return DAMAGE


func get_mag_max_ammo():
	return MAG_MAX_AMMO


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


func get_animation_use():
	return ANIMATION_USE


func get_audio_use():
	return AUDIO_USE


func get_audio_reload():
	return AUDIO_RELOAD


func get_audio_empty():
	return AUDIO_EMPTY


func get_weapon_state():
	if current_mag_ammo == MAG_MAX_AMMO:
		return WeaponState.FULL
	elif current_mag_ammo == 0:
		return WeaponState.EMPTY
	else:
		return WeaponState.NOT_FULL


func get_raycast():
	return raycast
#-------------------------------------------------------------------------------


# Setters
#-------------------------------------------------------------------------------
func set_raycast(argRaycast: RayCast3D):
	raycast = argRaycast
	raycast.set_target_position(Vector3(0, 0, -get_range()))
#-------------------------------------------------------------------------------


# Class related methods
#-------------------------------------------------------------------------------
# Not sure if these methods should actually exist... An item can be picked but
# a method should reflect a verb that the object executes. The player picks, 
# drops and equips the item. The item does not execute these actions,
# the player does... 
func use():
	return fire()


func pick(audioPlayerPath = null):
	super.pick(audioPlayerPath)
#	set_fire_audio()
	return self


func fire():
	if current_mag_ammo == 0:
		return false
	
	current_mag_ammo -= 1
	var collider = raycast.get_collider()
	if collider:
		# This should be changed. (Update 05.01.2022) Why/Because?
		#-----------------------------------------------------------------------
		if "healthSystem" in collider:
			collider.get_healthSystem().take_damage(DAMAGE)
		#-----------------------------------------------------------------------
	return true


func change_mag():
	current_mag_ammo = MAG_MAX_AMMO

func add_ammo(_ammo: int):
	pass
#	current_ammo += ammo


#func reload_gun():
#	change_mag()

func clone():
	var _clone = load(get_scene_file_path()).instantiate()
	_clone.current_mag_ammo = current_mag_ammo
	return _clone
#-------------------------------------------------------------------------------
