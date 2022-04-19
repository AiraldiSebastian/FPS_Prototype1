class_name EquipItemState extends BaseState


# Constructors / Initialzers
# ------------------------------------------------------------------------------
func _init(character, argAudioPlayer = null, argAudioPlayerContinuous = null).(character, argAudioPlayer, argAudioPlayerContinuous):
	pass
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_name():
	return "EquipItemState"
# ------------------------------------------------------------------------------


# Setters
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func handle_input(event):
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
	
	
	if charAnim.get_current_animation():
		return null
#	# Check if the player is already playing the current state animation
#	# ----------------------------------------------------------------------------------------------
#	# This is a safe way of comparing animations, instead of calling "get_animation_equip().get_name()"
#	# Since the method "get_animation_equip()" could return null, if the item does not has an equip animation
#	if charAnim.get_animation(charAnim.get_current_animation()) == character.playerCurrentItem.get_animation_equip():
#		return null
#	# ----------------------------------------------------------------------------------------------
#
#
#	# Else check for default animation of this State
#	# --------------------------------------------------------------------------
#	elif charAnim.get_current_animation() == "equip_item":
#		return null
#	# --------------------------------------------------------------------------
	
	
	# Now check for low priorities events
	# ----------------------------------------------------------------------------------------------
	if event.is_action_pressed("use_item"):
		return load("res://scripts/FiniteStateMachine/UseItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
	elif event.is_action_pressed("reload"):
		return load("res://scripts/FiniteStateMachine/ReloadState.gd").new(character, audioPlayer, audioPlayerContinuous)
	# ----------------------------------------------------------------------------------------------


func play_state():
	var charAnim = character.characterAnim
	var perspAnim = character.perspectiveAnim
	
	
	# First of all, equip the new items
	# ----------------------------------------------------------------------------------------------
	character.equip_items()
	# ----------------------------------------------------------------------------------------------
	
	# If the item has a animation for this State, add it to the animation player and play it
	# ----------------------------------------------------------------------------------------------
	var animation_equip = character.playerCurrentItem.get_animation_equip()
	if animation_equip:
		if !charAnim.has_animation(animation_equip.get_name()):
			charAnim.add_animation(animation_equip.get_name(), animation_equip)
			perspAnim.add_animation(animation_equip.get_name(), animation_equip)
		charAnim.play(animation_equip.get_name())
		perspAnim.play(animation_equip.get_name())
	# ----------------------------------------------------------------------------------------------
	
	
	# Else, play the default animation for this state
	# ----------------------------------------------------------------------------------------------
	else:
		charAnim.play("equip_item")
		perspAnim.play("equip_item")
	# ----------------------------------------------------------------------------------------------
	
	
# ------------------------------------------------------------------------------
