class_name Consumable extends Item


# Export member variables
#-------------------------------------------------------------------------------
@export var MAX_CHARGES: int : get = get_max_charges
#-------------------------------------------------------------------------------


# Member variables
#-------------------------------------------------------------------------------
var charges: int : get = get_charges, set = set_charges
#-------------------------------------------------------------------------------


# Constructors/Initializers
#-------------------------------------------------------------------------------
func _init(audioPlayerPath = null):
	super(audioPlayerPath)


func _ready():
	charges = MAX_CHARGES
#-------------------------------------------------------------------------------


# Getters
#-------------------------------------------------------------------------------
func get_max_charges():
	return MAX_CHARGES


func get_charges():
	return charges
#-------------------------------------------------------------------------------


# Setters
#-------------------------------------------------------------------------------
func set_charges(new_charges):
	charges = new_charges


func reduce_charges():
	charges -= 1
#-------------------------------------------------------------------------------
