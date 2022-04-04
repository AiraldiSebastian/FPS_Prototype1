extends Spatial

var healthSystem: HealthSystem
const MAX_HEALTH: int = 30


# Called when the node enters the scene tree for the first time.
func _ready():
	healthSystem = load("res://scripts/HealthSystem.gd").new(MAX_HEALTH, MAX_HEALTH)
	
