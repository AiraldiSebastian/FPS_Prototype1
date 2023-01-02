class_name EquipItemState extends BaseState


# Constructors / Initialzers
# ------------------------------------------------------------------------------
func _init(argCharacter,argAudioPlayer = null,argAudioPlayerContinuous = null):
	super(argCharacter,argAudioPlayer,argAudioPlayerContinuous)
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
	var retState = super.handle_input(event)
	if !retState:
		# Now check for low priorities events
		# ----------------------------------------------------------------------------------------------
		if event.is_action_pressed("use_item"):
			return load("res://scripts/FiniteStateMachine/UseItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
		elif event.is_action_pressed("reload"):
			return load("res://scripts/FiniteStateMachine/ReloadState.gd").new(character, audioPlayer, audioPlayerContinuous)
		else:
			return load("res://scripts/FiniteStateMachine/NullState.gd").new(character, audioPlayer, audioPlayerContinuous)
		# ----------------------------------------------------------------------------------------------
	else:
		return retState


func play_state():
	# First of all, equip the new items
	# ----------------------------------------------------------------------------------------------
	character.equip_items()
	# ----------------------------------------------------------------------------------------------
	print("YEP!")
	# If the item has a animation for this State, add it to the animation player and play it
	# Else, play the default animation for this state
	# ----------------------------------------------------------------------------------------------
	if !play_animation(Item.EQUIP):
		print("YEPx2!")
		character.characterAnim.play("equip_item")
		character.perspectiveAnim.play("equip_item")
	# ----------------------------------------------------------------------------------------------
	
	
# ------------------------------------------------------------------------------
