 class_name BaseState


# Member variables
# ------------------------------------------------------------------------------
# character: Character
var character
var audioPlayer: AudioStreamPlayer
var audioPlayerContinuous: AudioStreamPlayer
# ------------------------------------------------------------------------------


# Constructors / Initialzers
# ------------------------------------------------------------------------------
# argCharacter: Character
func _init(argCharacter, argAudioPlayer = null, argAudioPlayerContinuous = null):
	character = argCharacter
	audioPlayer = argAudioPlayer
	audioPlayerContinuous = argAudioPlayerContinuous
	print("AudioContinuous: ", argAudioPlayerContinuous)
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_name():
	return "BaseState"
# ------------------------------------------------------------------------------


# Setters
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func handle_input(_event):
	pass


func play_state():
	pass


func add_animation(animationName):
	var charAnim = character.characterAnim
	
	# If the item has a animation for this State, add it to the animation player and play it
	# ----------------------------------------------------------------------------------------------
	var animation = character.playerCurrentItem.get_animation(animationName)
	if animation:
		if !charAnim.has_animation(animation.get_name()):
			charAnim.add_animation(animation.get_name(), animation)
		charAnim.play(animation.get_name())
		return true
	else:
		return false
	# ----------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
