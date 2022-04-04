class_name Ammo extends Consumable

export var AMMO: int
export var POSITION: Vector3
export var ICON: StreamTexture

func use():
	return AMMO


func get_icon():
	return ICON


func equip():
	return self


func get_ammo():
	return AMMO


func set_player_position(player):
	transform.origin = POSITION
	global_transform.basis = player.global_transform.basis


func pick():
	print(get_parent())
	get_parent().remove_child(self)
	
#	# Play sound
#	audioPlayer = AudioManager.new(AUDIO_EQUIP)
#	add_child(audioPlayer)
#	audioPlayer.play_sound()
#	# ----------
	
	return self
