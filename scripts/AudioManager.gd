class_name AudioManager extends AudioStreamPlayer


# Member variables
# ------------------------------------------------------------------------------
var timer: Timer
# ------------------------------------------------------------------------------


# Constructors / Initializers
# ------------------------------------------------------------------------------
func _init(stream: AudioStream):
	if stream:
		set_stream(stream)
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func play_sound():
	# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
	play()
# ------------------------------------------------------------------------------
