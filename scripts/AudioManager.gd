class_name AudioManager extends AudioStreamPlayer

var timer: Timer


func _init(stream: AudioStream):
	if stream:
		set_stream(stream)

func play_sound():
	# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
	play()

# This doesnt work, because we are stopping execution of program by waiting for timer!
#func play_multiple_sounds(arrayAudio, arrayDelay):
#	print("play_multiple_sounds called!")
#	timer = Timer.new()
#	timer.set_one_shot(true)
#	add_child(timer)
#	var index: int = 0
#	while index < arrayAudio.size():
#		if !is_playing() and timer.is_stopped():
#			print("Playing ", index + 1," sound")
#			set_stream(arrayAudio[index])
#			play()
#			connect("finished", timer, "start", [arrayDelay[index]])
#			index += 1
#		else:
#			print("stuck in loop xD")
#
#	if timer.is_stopped():
#		queue_free()
