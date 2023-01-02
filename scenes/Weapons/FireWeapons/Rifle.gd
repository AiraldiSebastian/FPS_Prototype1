extends FireWeapon


# Export member variables
#-------------------------------------------------------------------------------
@export var AUDIO_CLIPOUT: AudioStream
@export var AUDIO_CLIPIN: AudioStream
@export var AUDIO_CLIPHIT: AudioStream
@export var AUDIO_BOLTPULL: AudioStream
@export var AUDIO_BOLTFORWARD: AudioStream
#-------------------------------------------------------------------------------


# Constructors/Initializers
#-------------------------------------------------------------------------------
func _init(audioPlayerPath = null):
	super(audioPlayerPath)
	pass


func _ready():
	set_reload_audio()
#-------------------------------------------------------------------------------


# Getters
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------


# Setters
#-------------------------------------------------------------------------------
func set_reload_audio():
	if AUDIO_PLAYER_PATH:
		var track_idx = ANIMATION_RELOAD.add_track(Animation.TYPE_AUDIO)
		ANIMATION_RELOAD.track_set_path(track_idx, AUDIO_PLAYER_PATH)
		
		# warning-ignore:return_value_discarded
		ANIMATION_RELOAD.audio_track_insert_key(track_idx, 0.5, AUDIO_CLIPOUT)
		# warning-ignore:return_value_discarded
		ANIMATION_RELOAD.audio_track_insert_key(track_idx, 1.08, AUDIO_CLIPIN)
		# warning-ignore:return_value_discarded
		ANIMATION_RELOAD.audio_track_insert_key(track_idx, 1.14, AUDIO_CLIPHIT)
		# warning-ignore:return_value_discarded
		ANIMATION_RELOAD.audio_track_insert_key(track_idx, 1.77, AUDIO_BOLTPULL)
		# warning-ignore:return_value_discarded
		ANIMATION_RELOAD.audio_track_insert_key(track_idx, 1.94, AUDIO_BOLTFORWARD)
#-------------------------------------------------------------------------------


# Others
#-------------------------------------------------------------------------------
func pick(audioPlayerPath = null):
	super.pick(audioPlayerPath)
	set_reload_audio()
	return self
#-------------------------------------------------------------------------------
