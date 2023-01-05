class_name HealthSystem


# Signals
# ------------------------------------------------------------------------------
signal isDead
signal healthChange
# ------------------------------------------------------------------------------


# Member variables
# ------------------------------------------------------------------------------
var MAX_HEALTH: int    : get = get_max_health
var currentHealth: int : get = get_currentHealth
# ------------------------------------------------------------------------------


# Constructors / Initializers
# ------------------------------------------------------------------------------
func _init(arg_MAX_HEALTH,arg_currentHealth):
	MAX_HEALTH = arg_MAX_HEALTH
	currentHealth = arg_currentHealth
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_max_health():
	return MAX_HEALTH


func get_currentHealth():
	return currentHealth
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func take_damage(points):
	currentHealth -= points
	
	emit_signal("healthChange")
	if currentHealth <= 0:
		emit_signal("isDead")


func take_health(points):
	currentHealth += points
	if currentHealth > MAX_HEALTH:
		currentHealth = MAX_HEALTH
	
	emit_signal("healthChange")
# ------------------------------------------------------------------------------
