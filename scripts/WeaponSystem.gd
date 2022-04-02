class_name WeaponSystem extends Spatial

export var NAME:			String
export var DAMAGE:			int
export var MAX_AMMO:		int
export var MAG_MAX_AMMO:	int
export var DISTANCE:		int
export var POSITION:		Vector3
export var ICON:			StreamTexture
export var AUDIO_FIRE:		AudioStream
export var AUDIO_RELOAD:	AudioStream
export var AUDIO_EMPTY:		AudioStream
export var AUDIO_EQUIP:		AudioStream

var current_mag_ammo:	int
var current_ammo:		int


func _ready():
	current_mag_ammo = MAG_MAX_AMMO
	current_ammo = MAX_AMMO


func set_player_position(player):
	transform.origin = POSITION
	global_transform.basis = player.global_transform.basis


func pick(audioPlayer):
	print(get_parent())
	get_parent().remove_child(self)
	audioPlayer.set_stream(AUDIO_EQUIP)
	audioPlayer.play()
	return self


func get_type():
	return "WeaponSystem"


func get_icon():
	return ICON


func fire(weaponRaycast: RayCast, audioPlayer):
	if current_mag_ammo == 0:
		audioPlayer.set_stream(AUDIO_EMPTY)
	else:
		audioPlayer.set_stream(AUDIO_FIRE)
		
		current_mag_ammo -= 1
		var collider = weaponRaycast.get_collider()
		if collider:
#			print("Weapon: ", NAME, " shot: ", collider)
			if "healthSystem" in collider:
				collider.healthSystem.take_damage(DAMAGE)
#				print(collider," health left: ", collider.healthSystem.get_health())
	audioPlayer.play()


func equip(audioPlayer):
	audioPlayer.set_stream(AUDIO_EQUIP)
	audioPlayer.play()
	return self


func reload(audioPlayer):
	audioPlayer.set_stream(AUDIO_RELOAD)
	audioPlayer.play()
	
	var reload_ammo_needed = MAG_MAX_AMMO - current_mag_ammo
	
	if current_ammo - reload_ammo_needed >= 0:
		current_ammo -= reload_ammo_needed
		current_mag_ammo += reload_ammo_needed
	else:
		current_mag_ammo += current_ammo
		current_ammo = 0


func get_current_mag_ammo():
	return current_mag_ammo


func get_current_ammo():
	return current_ammo


func get_max_ammo():
	return MAX_AMMO


func get_mag_max_ammo():
	return MAG_MAX_AMMO


func get_distance():
	return DISTANCE
