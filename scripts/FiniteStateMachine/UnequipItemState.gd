class_name UnequipItemState extends BaseState


# Constructors / Initialzers
# ------------------------------------------------------------------------------
func _init(character, argAudioPlayer = null, argAudioPlayerContinuous = null).(character, argAudioPlayer, argAudioPlayerContinuous):
	pass
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_name():
	return "UnequipItemState"
# ------------------------------------------------------------------------------


# Setters
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func handle_input(event):
	var charAnim = character.characterAnim
	
	
	if charAnim.get_current_animation():
		return null
#	# Check if the character is carrying an item. (Edge Case)
#	# Theoritcally this case should not be possible, but since this is the first State
#	# that the character will be in, it might be the case, that the player has no initial
#	# items on it, and therefore the "playerCurrentItem" will be null
#	# ----------------------------------------------------------------------------------------------
#	if character.playerCurrentItem:
#		# Check if the player is already playing the current state animation
#		# ------------------------------------------------------------------------------------------
#		# This is a safe way of comparing animations, instead of calling "get_animation_equip().get_name()"
#		# Since the method "get_animation_equip()" could return null, if the item does not has an equip animation
#		if charAnim.get_animation(charAnim.get_current_animation()) == character.playerCurrentItem.get_animation_unequip():
#			return null
#		# ------------------------------------------------------------------------------------------
#
#
#		# Else check for default animation of this State
#		# ----------------------------------------------------------------------
#		elif charAnim.get_current_animation() == "unequip_item":
#			return null
#		# ----------------------------------------------------------------------
#	# ----------------------------------------------------------------------------------------------
	
	
	
	# Now check for low priorities events
	# ----------------------------------------------------------------------------------------------
	if event.is_action_pressed("equip_item"):
		return load("res://scripts/FiniteStateMachine/EquipItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
	# ----------------------------------------------------------------------------------------------


func play_state():
	var charAnim = character.characterAnim
	var perspAnim = character.perspectiveAnim
	
	
	# Check if the character is carrying an item. (Edge Case)
	# Theoritcally this case should not be possible, but since this is the first State
	# that the character will be in, it might be the case, that the player has no initial
	# items on it, so therefore the "playerCurrentItem" will be null
	# --------------------------------------------------------------------------
	if !character.playerCurrentItem:
		# Set the character to the "unequip_item" position
		# ----------------------------------------------------------------------
		charAnim.play("unequip_item")
		perspAnim.play("unequip_item")
		# ----------------------------------------------------------------------
		return
	# --------------------------------------------------------------------------
	
	
	# If the item has a animation for this State, add it to the animation player and play it
	# ----------------------------------------------------------------------------------------------
	var animation_unequip = character.playerCurrentItem.get_animation_unequip()
	if animation_unequip:
		if !charAnim.has_animation(animation_unequip.get_name()):
			charAnim.add_animation(animation_unequip.get_name(), animation_unequip)
			perspAnim.add_animation(animation_unequip.get_name(), animation_unequip)
		charAnim.play(animation_unequip.get_name())
		perspAnim.play(animation_unequip.get_name())
	# ----------------------------------------------------------------------------------------------
	
	
	# Else, play the default animation for this state
	# ----------------------------------------------------------------------------------------------
	else:
		charAnim.play("unequip_item")
		perspAnim.play("unequip_item")
	# ----------------------------------------------------------------------------------------------
	
		
	# At last, unequip the items
	# ----------------------------------------------------------------------------------------------
	character.unequip_items()
	# ----------------------------------------------------------------------------------------------
	
	
# ------------------------------------------------------------------------------
