class_name MedicKit extends Consumable

export var HEAL_EFFECT: int
export var POSITION: Vector3
export var ICON: StreamTexture

#var charges: int setget set_charges, get_charges

func use():
	return HEAL_EFFECT


func get_icon():
	return ICON


func equip():
	return self


func get_healing():
	return HEAL_EFFECT


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
