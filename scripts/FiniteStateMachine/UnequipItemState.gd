class_name UnequipItemState extends BaseState


# Constructors / Initialzers
# ------------------------------------------------------------------------------
func _init(argCharacter,argAudioPlayer = null,argAudioPlayerContinuous = null):
	super(argCharacter,argAudioPlayer,argAudioPlayerContinuous)
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
	var retState = super.handle_input(event)
	if !retState:
		# Now check for low priorities events
		# ----------------------------------------------------------------------------------------------
		if event.is_action_pressed("equip_item"):
			print("hellow")
			return load("res://scripts/FiniteStateMachine/EquipItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
		else:
			return load("res://scripts/FiniteStateMachine/NullState.gd").new(character, audioPlayer, audioPlayerContinuous)
		# ----------------------------------------------------------------------------------------------
	else:
		return retState


func play_state():
	# Check if the character is carrying an item. (Edge Case)
	# Theoritcally this case should not be possible, but since this is the first State
	# that the character will be in, it might be the case, that the player has no initial
	# items checked it, so therefore the "playerCurrentItem" will be null
	# --------------------------------------------------------------------------
	if !character.playerCurrentItem:
		# Set the character to the "unequip_item" position
		# ----------------------------------------------------------------------
		character.characterAnim.play("unequip_item")
		character.perspectiveAnim.play("unequip_item")
		# ----------------------------------------------------------------------
		return
	# --------------------------------------------------------------------------
	
	
	# If the item has a animation for this State, add it to the animation player and play it
	# Else, play the default animation for this state
	# ----------------------------------------------------------------------------------------------
	if !play_animation(Item.UNEQUIP):
		character.characterAnim.play("unequip_item")
		character.perspectiveAnim.play("unequip_item")
	# ----------------------------------------------------------------------------------------------
	
	
	# At last, unequip the items
	# ----------------------------------------------------------------------------------------------
	character.unequip_items()
	# ----------------------------------------------------------------------------------------------
	
	
# ------------------------------------------------------------------------------
