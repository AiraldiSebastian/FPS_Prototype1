class_name MedicKit extends Consumable

# Export member variables
#-------------------------------------------------------------------------------
export var HEAL_EFFECT: int setget ,get_heal_effect
export var ANIMATION_USE: Animation setget ,get_animation_use
#-------------------------------------------------------------------------------


# Constructors/Initializers
#-------------------------------------------------------------------------------
func _init(audioPlayerPath = null).(audioPlayerPath):
	pass


func _ready():
	charges = MAX_CHARGES
#-------------------------------------------------------------------------------


# Getters
#-------------------------------------------------------------------------------
func get_heal_effect():
	return HEAL_EFFECT


func get_animation_use():
	return ANIMATION_USE
#-------------------------------------------------------------------------------


# Others
# ------------------------------------------------------------------------------
func use():
	if get_charges() > 0:
		reduce_charges()
		return get_heal_effect()
# ------------------------------------------------------------------------------
