extends KinematicBody

export var MAX_SPEED:	int
export var ACCEL:		int
export var GRAVITY:		int

var zombieVel: Vector3 = Vector3()

var healthSystem: HealthSystem

var AREA: Area

var bodyInArea

# Called when the node enters the scene tree for the first time.
func _ready():
	AREA = $Area
	# warning-ignore:return_value_discarded
	AREA.connect("body_entered", self, "add_bodyInArea")
	# warning-ignore:return_value_discarded
	AREA.connect("body_exited", self, "remove_bodyInArea")
	
	healthSystem = HealthSystem.new(100, 100)
	# warning-ignore:return_value_discarded
	healthSystem.connect("isDead", self, "is_dead")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if bodyInArea:
		look_at(bodyInArea.global_transform.origin, Vector3(0, 1, 0))
		zombieVel = zombieVel.linear_interpolate(-global_transform.basis.z * MAX_SPEED, delta * ACCEL)
	else:
		zombieVel = Vector3(0, 0, 0)
	zombieVel = move_and_slide(zombieVel, Vector3(0, 1, 0))

func add_bodyInArea(player):
	bodyInArea = player


func remove_bodyInArea(player):
	if bodyInArea == player:
		bodyInArea = null

func is_dead():
	queue_free()
