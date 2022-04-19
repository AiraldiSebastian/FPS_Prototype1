class_name Consumable extends Item


# Export member variables
#-------------------------------------------------------------------------------
export var MAX_CHARGES: int setget ,get_max_charges
#-------------------------------------------------------------------------------


# Member variables
#-------------------------------------------------------------------------------
var charges: int setget set_charges,get_charges
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
