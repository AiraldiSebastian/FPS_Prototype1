class_name WeaponSystem extends Spatial

export var NAME:			String
export var DAMAGE:			int
export var MAX_AMMO:		int
export var POSITION:		Vector3
export var ICON:			StreamTexture
export var AUDIO_FIRE:		AudioStream
export var AUDIO_RELOAD:	AudioStream
export var AUDIO_EMPTY:		AudioStream
export var AUDIO_EQUIP:		AudioStream

var current_ammo:	int


func _ready():
	transform.origin = POSITION
	current_ammo = MAX_AMMO


func fire(camera, direct_space_state, audioPlayer):
	if current_ammo == 0:
		audioPlayer.set_stream(AUDIO_EMPTY)
	else:
		current_ammo -= 1
		audioPlayer.set_stream(AUDIO_FIRE)
		var collision = direct_space_state.intersect_ray(camera.global_transform.origin, camera.global_transform.origin + camera.global_transform.basis.z * -20)
		if collision and collision.collider:
			print(collision.collider.get_parent().to_string())
			if "healthSystem" in collision.collider.get_parent():
				collision.collider.get_parent().healthSystem.take_damage(DAMAGE)
				print(collision.collider.get_parent().healthSystem.get_health())
				
	audioPlayer.play()

func reload(audioPlayer):
	audioPlayer.set_stream(AUDIO_RELOAD)
	audioPlayer.play()
	current_ammo = MAX_AMMO


func get_current_ammo():
	return current_ammo


func get_max_ammo():
	return MAX_AMMO


func equip(audioPlayer):
	audioPlayer.set_stream(AUDIO_EQUIP)
	audioPlayer.play()
	return self
