class_name UseItemState extends BaseState


# Constructors / Initialzers
# ------------------------------------------------------------------------------
func _init(character, argAudioPlayer = null, argAudioPlayerContinuous = null).(character, argAudioPlayer, argAudioPlayerContinuous):
	pass
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_name():
	return "UseItemState"
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
			return self
		elif event.is_action_released("use_item"):
			return load("res://scripts/FiniteStateMachine/NullState.gd").new(character, audioPlayer, audioPlayerContinuous)
		elif event.is_action_pressed("reload"):
			return load("res://scripts/FiniteStateMachine/ReloadState.gd").new(character, audioPlayer, audioPlayerContinuous)
		else:
			return load("res://scripts/FiniteStateMachine/NullState.gd").new(character, audioPlayer, audioPlayerContinuous)
		# ----------------------------------------------------------------------------------------------
	else:
		return retState


func play_state():
	# Fire Weapon
	# ----------------------------------------------------------------------------------------------
	if character.playerCurrentItem is FireWeapon:
		if character.use_item(character.playerCurrentItem):
			# If the item has a animation for this State, add it to the animation player and play it
			# Else, play the default animation for this state
			# ------------------------------------------------------------------------------------------
			if !play_animation(Item.USE):
				character.characterAnim.play("use_item")
				character.perspectiveAnim.play("use_item")
			
			# If the item has an Audio available for its use, play the sound
			# ------------------------------------------------------------------
			if character.playerCurrentItem.get_audio_use():
				var audioPlayerTest = AudioManager.new(character.playerCurrentItem.get_audio_use())
				character.add_child(audioPlayerTest)
				audioPlayerTest.play_sound()
				# ------------------------------------------------------------------
		
		
		# Play empty sound
		# ----------------------------------------------------------------------------------------------
		else:
			if !audioPlayer.is_playing():
				audioPlayer.set_stream(character.playerCurrentItem.get_audio_empty())
				audioPlayer.play()
		# ----------------------------------------------------------------------------------------------
	# ----------------------------------------------------------------------------------------------
	
	
	# MedicKit
	# ----------------------------------------------------------------------------------------------
	elif character.playerCurrentItem is Medkit:
		# If the item has a animation for this State, add it to the animation player and play it
		# Else, play the default animation for this state
		# ------------------------------------------------------------------------------------------
		if !play_animation(Item.USE):
			character.characterAnim.play("use_item")
			character.perspectiveAnim.play("use_item")
		# ------------------------------------------------------------------------------------------
		
		# Use the item
		# ------------------------------------------------------------------------------------------
		character.use_item(character.playerCurrentItem)
		# ------------------------------------------------------------------------------------------
	# ----------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
