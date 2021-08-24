extends Spatial

# All of the audio files.
# You will need to provide your own sound files.
var audio_pistol_shot = preload("res://assets/sounds/deagle-1.wav")
var audio_gun_cock = preload("res://assets/sounds/gun_semi_reload_01.wav")
var audio_rifle_shot = preload("res://assets/sounds/ak47-1.wav")

var audio_node = null

func _ready():
	audio_node = $Audio_Stream_Player
	audio_node.connect("finished", self, "destroy_self")
	audio_node.stop()


func play_sound(sound_name, position=null):

	if audio_pistol_shot == null or audio_rifle_shot == null or audio_gun_cock == null:
		print ("Audio not set!")
		queue_free()
		return

	if sound_name == "Pistol_shot":
		audio_node.stream = audio_pistol_shot
	elif sound_name == "Rifle_shot":
		audio_node.stream = audio_rifle_shot
	elif sound_name == "Gun_cock":
		audio_node.stream = audio_gun_cock
	else:
		print ("UNKNOWN STREAM")
		queue_free()
		return

	# If you are using an AudioStreamPlayer3D, then uncomment these lines to set the position.
	#if audio_node is AudioStreamPlayer3D:
	#    if position != null:
	#        audio_node.global_transform.origin = position

	audio_node.play()


func destroy_self():
	audio_node.stop()
	queue_free()
