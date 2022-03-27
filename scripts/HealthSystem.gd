class_name HealthSystem extends Spatial

# Member invariables
var MAX_HEALTH: int
var currentHealth: int

func _init(arg_MAX_HEALTH, arg_currentHealth):
	MAX_HEALTH = arg_MAX_HEALTH
	currentHealth = arg_currentHealth


func get_MAX_HEALTH():
	return MAX_HEALTH


func take_damage(points):
	currentHealth -= points


func take_health(points):
	currentHealth += points
	if currentHealth > MAX_HEALTH:
		currentHealth = MAX_HEALTH


func set_health(points):
#	Method 1
#	---------------------------------------------------------------------------------------------
	currentHealth = clamp(currentHealth + points, 0, MAX_HEALTH)
#	---------------------------------------------------------------------------------------------
	
#	Method 2
#	---------------------------------------------------------------------------------------------
#	currentHealth += points;
#
#	if currentHealth < 0:
#		currentHealth = 0
#	elif currentHealth > MAX_HEALTH:
#		currentHealth = MAX_HEALTH
#	---------------------------------------------------------------------------------------------
	print("Current health: ", currentHealth)

func get_health():
	return currentHealth

func is_health_zero():
	return currentHealth <= 0
