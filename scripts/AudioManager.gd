class_name AudioManager extends AudioStreamPlayer


# Member variables
# ------------------------------------------------------------------------------
var timer: Timer
# ------------------------------------------------------------------------------


# Constructors / Initializers
# ------------------------------------------------------------------------------
func _init(argStream: AudioStream):
	if argStream:
		set_stream(argStream)
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func play_sound():
	# warning-ignore:return_value_discarded
	connect("finished",Callable(self,"queue_free"))
	play()
# ------------------------------------------------------------------------------
