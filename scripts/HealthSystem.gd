class_name HealthSystem

# Member invariables
export var MAX_HEALTH: int

# Member variables
export var currentHealth: int

# Called when the node enters the scene tree for the first time.
#func _ready():

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

func get_health():
	return currentHealth

func is_health_zero():
	return currentHealth == 0
