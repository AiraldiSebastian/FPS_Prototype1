class_name ReloadState extends BaseState


# Constructors / Initialzers
# ------------------------------------------------------------------------------
func _init(character, argAudioPlayer = null, argAudioPlayerContinuous = null).(character, argAudioPlayer, argAudioPlayerContinuous):
	pass
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_name():
	return "ReloadState"
# ------------------------------------------------------------------------------


# Setters
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func handle_input(event):
	var retState = .handle_input(event)
	if !retState:
		# Now check for low priorities events
		# ----------------------------------------------------------------------------------------------
		if event.is_action_pressed("use_item"):
			return load("res://scripts/FiniteStateMachine/UseItemState.gd").new(character, audioPlayer, audioPlayerContinuous)
		elif event.is_action_pressed("reload"):
			return self
		else:
			return load("res://scripts/FiniteStateMachine/NullState.gd").new(character, audioPlayer, audioPlayerContinuous)
		# ----------------------------------------------------------------------------------------------
	else:
		return retState


func play_state():
	if character.playerCurrentItem is FireWeapon:
		# Check if a reload is possible. 
		# ----------------------------------------------------------------------------------------------
		var weaponState = character.playerCurrentItem.get_weapon_state()
		if weaponState == FireWeapon.WeaponState.NOT_FULL or weaponState == FireWeapon.WeaponState.EMPTY:
			# If the item has a animation for this State, add it to the animation player and play it
			# Else, play the default animation for this state
			# ------------------------------------------------------------------------------------------
			if !play_animation(FireWeapon.RELOAD):
				character.characterAnim.play("reload")
				character.perspectiveAnim.play("reload")
			# ------------------------------------------------------------------------------------------
			character.reload()
		# ----------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
