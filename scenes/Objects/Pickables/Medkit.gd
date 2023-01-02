class_name Medkit extends Consumable

# Export member variables
#-------------------------------------------------------------------------------
@export var HEAL_EFFECT: int : get = get_heal_effect
#-------------------------------------------------------------------------------


# Constructors/Initializers
#-------------------------------------------------------------------------------
func _init(audioPlayerPath = null):
	super(audioPlayerPath)
	pass


func _ready():
	charges = MAX_CHARGES
#-------------------------------------------------------------------------------


# Getters
#-------------------------------------------------------------------------------
func get_class():
	return "Medkit"

func get_heal_effect():
	return HEAL_EFFECT
#-------------------------------------------------------------------------------


# Others
# ------------------------------------------------------------------------------
func use():
	if get_charges() > 0:
		reduce_charges()
		return get_heal_effect()
# ------------------------------------------------------------------------------
