class_name WeaponSystem extends Spatial

export var NAME:			String
export var DAMAGE:			int
export var FIRE_RATE:		float
export var RELOAD_TIME:		float
export var MAX_AMMO:		int
export var MAG_MAX_AMMO:	int
export var DISTANCE:		int
export var POSITION:		Vector3
export var ICON:			StreamTexture
export var AUDIO_FIRE:		AudioStream
export var AUDIO_RELOAD:	AudioStream
export var AUDIO_EMPTY:		AudioStream
export var AUDIO_EQUIP:		AudioStream

var audioPlayer:		AudioManager
var current_mag_ammo:	int
var current_ammo:		int
var timer:	Timer

func _ready():
	current_mag_ammo = MAG_MAX_AMMO
	current_ammo = MAX_AMMO
	timer = Timer.new()
	timer.set_one_shot(true)
	add_child(timer)


func set_player_position(player):
	transform.origin = POSITION
	global_transform.basis = player.global_transform.basis


func pick():
	print(get_parent())
	get_parent().remove_child(self)
	
	# Play sound
	audioPlayer = AudioManager.new(AUDIO_EQUIP)
	add_child(audioPlayer)
	audioPlayer.play_sound()
	# ----------
	
	return self


func get_type():
	return "WeaponSystem"


func get_icon():
	return ICON


func fire(weaponRaycast: RayCast):
	if !timer.is_stopped():
		return
	
	timer.start(FIRE_RATE)
	
	audioPlayer = AudioManager.new(AUDIO_EMPTY if current_mag_ammo == 0 else AUDIO_FIRE)
	
	if current_mag_ammo != 0:
		current_mag_ammo -= 1
		var collider = weaponRaycast.get_collider()
		if collider:
#			print("Weapon: ", NAME, " shot: ", collider)
			if "healthSystem" in collider:
				collider.healthSystem.take_damage(DAMAGE)
#				print(collider," health left: ", collider.healthSystem.get_health())
	
	# Play sound
	add_child(audioPlayer)
	audioPlayer.play_sound()
	# ----------


func equip():
	
	# Play sound
	audioPlayer = AudioManager.new(AUDIO_EQUIP)
	add_child(audioPlayer)
	audioPlayer.play_sound()
	# ----------
	
	return self


func reload():
	if !timer.is_stopped():
		return
	if current_mag_ammo == MAG_MAX_AMMO:
		return

	timer.start(RELOAD_TIME)
	
	var reload_ammo_needed = MAG_MAX_AMMO - current_mag_ammo
	
	if current_ammo - reload_ammo_needed >= 0:
		current_ammo -= reload_ammo_needed
		current_mag_ammo += reload_ammo_needed
	else:
		current_mag_ammo += current_ammo
		current_ammo = 0
	
	# Play sound
	audioPlayer = AudioManager.new(AUDIO_RELOAD)
	add_child(audioPlayer)
	audioPlayer.play_sound()
	# ----------

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
