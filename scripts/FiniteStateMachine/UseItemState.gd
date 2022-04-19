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
#	if charAnim.get_animation(charAnim.get_current_animation()) == character.playerCurrentItem.get_animation_use():
#		return null
#	# ----------------------------------------------------------------------------------------------
#
#
#	# Else check for default animation of this State
#	# --------------------------------------------------------------------------
#	elif charAnim.get_current_animation() == "use_item":
#		return null
#	# --------------------------------------------------------------------------	
	
	
	# Now check for low priorities events
	# ----------------------------------------------------------------------------------------------
	if event.is_action_pressed("use_item"):
		return self
	elif event.is_action_released("use_item"):
		return null
	elif event.is_action_pressed("reload"):
		return load("res://scripts/FiniteStateMachine/ReloadState.gd").new(character, audioPlayer, audioPlayerContinuous)
	# ----------------------------------------------------------------------------------------------

func play_state():
	var charAnim = character.characterAnim
	var perspAnim = character.perspectiveAnim
	
	
	# Fire Weapon
	# ----------------------------------------------------------------------------------------------
	if character.playerCurrentItem is FireWeapon:
		if character.playerCurrentItem.use():
			# If the item has a animation for this State, add it to the animation player and play it
			# ------------------------------------------------------------------------------------------
			var animation_use = character.playerCurrentItem.get_animation_use()
			if animation_use:
				if !charAnim.has_animation(animation_use.get_name()):
					charAnim.add_animation(animation_use.get_name(), animation_use)
					perspAnim.add_animation(animation_use.get_name(), animation_use)
				charAnim.play(animation_use.get_name())
				perspAnim.play(animation_use.get_name())
				
				# If the item has an Audio available for its use, play the sound
				# ------------------------------------------------------------------
				if character.playerCurrentItem.get_audio_use():
					var audioPlayerTest = AudioManager.new(character.playerCurrentItem.get_audio_use())
					character.add_child(audioPlayerTest)
					audioPlayerTest.play_sound()
				# ------------------------------------------------------------------
				
				
				print("Specific use animation!")
			# ------------------------------------------------------------------------------------------
			
			# Else, play the default animation for this state
			# ------------------------------------------------------------------------------------------
			else:
				charAnim.play("use_item")
				perspAnim.play("use_item")
				# If the item has an Audio available for its use, play the sound
				# ------------------------------------------------------------------
				if character.playerCurrentItem.get_audio_use():
					var audioPlayerTest = AudioManager.new(character.playerCurrentItem.get_audio_use())
					character.add_child(audioPlayerTest)
					audioPlayerTest.play_sound()
				# ------------------------------------------------------------------
				
				
				print("Default use animation!")
			# ------------------------------------------------------------------------------------------
		
		
		# Play empty sound
		# ----------------------------------------------------------------------------------------------
		else:
			if !audioPlayer.is_playing():
				print("playing try")
				audioPlayer.set_stream(character.playerCurrentItem.get_audio_empty())
				audioPlayer.play()
#			var audioPlayerTest = AudioManager.new(character.playerCurrentItem.get_audio_empty())
#			character.add_child(audioPlayerTest)
#			audioPlayerTest.play_sound()
		# ----------------------------------------------------------------------------------------------
		
	# ----------------------------------------------------------------------------------------------
	
	
	# MedicKit
	# ----------------------------------------------------------------------------------------------
	elif character.playerCurrentItem is MedicKit:
		# If the item has a animation for this State, add it to the animation player and play it
		# ------------------------------------------------------------------------------------------
		var animation_use = character.playerCurrentItem.get_animation_use()
		if animation_use:
			if !charAnim.has_animation(animation_use.get_name()):
				charAnim.add_animation(animation_use.get_name(), animation_use)
				perspAnim.add_animation(animation_use.get_name(), animation_use)
			charAnim.play(animation_use.get_name())
			perspAnim.play(animation_use.get_name())
		# ------------------------------------------------------------------------------------------
		
		# Else, play the default animation for this state
		# ------------------------------------------------------------------------------------------
		else:
			charAnim.play("use_item")
			perspAnim.play("use_item")
		# ------------------------------------------------------------------------------------------
		
		# Use the item
		# ------------------------------------------------------------------------------------------
		character.healthSystem.take_health(character.UI_HotbarMarker.use_item())
		# ------------------------------------------------------------------------------------------
		
		
	# ----------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
