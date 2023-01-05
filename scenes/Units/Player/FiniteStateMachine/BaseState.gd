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
func _init(argCharacter,argAudioPlayer = null,argAudioPlayerContinuous = null):
	character = argCharacter
	audioPlayer = argAudioPlayer
	audioPlayerContinuous = argAudioPlayerContinuous
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
func handle_input(event) -> BaseState:
	var charAnim = character.characterAnim
	var perspAnim = character.perspectiveAnim
	
	# Unequip and Equip items have highest priority
	# ----------------------------------------------------------------------------------------------
	if event.is_action_pressed("unequip_item"):
		charAnim.stop(true)
		perspAnim.stop(true)
		return load("res://scenes/Units/Player/FiniteStateMachine/UnequipItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
	elif event.is_action_pressed("equip_item"):
		charAnim.stop(true)
		perspAnim.stop(true)
		return load("res://scenes/Units/Player/FiniteStateMachine/EquipItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
	# ----------------------------------------------------------------------------------------------
	
	# Check if the player is ocuppied playing another animation
	# ----------------------------------------------------------------------------------------------
	if charAnim.get_current_animation():
		return load("res://scenes/Units/Player/FiniteStateMachine/NullState.gd").new(character, audioPlayer, audioPlayerContinuous)
	# ----------------------------------------------------------------------------------------------
	
	# Why not return NullState? This question still has to be solved.
	# Probably changing to return NullSate in the future, if no answer is found.
	return null


func play_state():
	pass


func play_animation(animationName):
	var charAnim : AnimationPlayer = character.characterAnim
	var perspAnim : AnimationPlayer = character.perspectiveAnim
	
	# If the item has a animation for this State, add it to the animation player and play it
	# ----------------------------------------------------------------------------------------------
	var animation = character.playerCurrentItem.get_animation(animationName)
	if animation:
		if !charAnim.has_animation(animation.get_name()) or !perspAnim.has_animation(animation.get_name()):
			charAnim.get_animation_library("").add_animation(animation.get_name(), animation)
			perspAnim.get_animation_library("").add_animation(animation.get_name(), animation)
		charAnim.play(animation.get_name())
		perspAnim.play(animation.get_name())
		return true
	else:
		return false
	# ----------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
