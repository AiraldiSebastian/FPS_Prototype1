class_name HealthSystem


# Signals
# ------------------------------------------------------------------------------
signal isDead
signal healthChange
# ------------------------------------------------------------------------------


# Member variables
# ------------------------------------------------------------------------------
var MAX_HEALTH: int
var currentHealth: int
# ------------------------------------------------------------------------------


# Constructors / Initializers
# ------------------------------------------------------------------------------
func _init(arg_MAX_HEALTH,arg_currentHealth):
	MAX_HEALTH = arg_MAX_HEALTH
	currentHealth = arg_currentHealth
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_MAX_HEALTH():
	return MAX_HEALTH


func get_health():
	return currentHealth
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func take_damage(points):
	currentHealth -= points
	
	emit_signal("healthChange")
	if is_health_zero():
		emit_signal("isDead")
	


func take_health(points):
	currentHealth += points
	if currentHealth > MAX_HEALTH:
		currentHealth = MAX_HEALTH
	
	emit_signal("healthChange")


func is_health_zero():
	return currentHealth <= 0
# ------------------------------------------------------------------------------
