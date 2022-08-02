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
func _init(argCharacter, argAudioPlayer = null, argAudioPlayerContinuous = null):
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
		return load("res://scripts/FiniteStateMachine/UnequipItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
	elif event.is_action_pressed("equip_item"):
		charAnim.stop(true)
		perspAnim.stop(true)
		return load("res://scripts/FiniteStateMachine/EquipItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
	# ----------------------------------------------------------------------------------------------
	
	
	# Check if the player is ocuppied playing another animation
	# ----------------------------------------------------------------------------------------------
	if charAnim.get_current_animation():
		return load("res://scripts/FiniteStateMachine/NullState.gd").new(character, audioPlayer, audioPlayerContinuous)
	# ----------------------------------------------------------------------------------------------
	
	return null


func play_state():
	pass


func play_animation(animationName):
	var charAnim = character.characterAnim
	var perspAnim = character.perspectiveAnim
	
	# If the item has a animation for this State, add it to the animation player and play it
	# ----------------------------------------------------------------------------------------------
	var animation = character.playerCurrentItem.get_animation(animationName)
	if animation:
		if !charAnim.has_animation(animation.get_name()):
			charAnim.add_animation(animation.get_name(), animation)
			perspAnim.add_animation(animation.get_name(), animation)
		charAnim.play(animation.get_name())
		perspAnim.play(animation.get_name())
		print("SpecificAnimation")
		return true
	else:
		return false
	# ----------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
