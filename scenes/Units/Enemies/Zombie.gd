extends CharacterBody3D

@export var MAX_SPEED:	int
@export var ACCEL:		int
@export var GRAVITY:		int

var zombieVel: Vector3 = Vector3()

var healthSystem: HealthSystem

var AREA_DETECTION: Area3D
var AREA_ATTACK: Area3D
var SPACE_ATTACK: Area3D

var bodyInAttackArea
var bodyInDetectionArea

var zombieAnim: AnimationPlayer

@export var DAMAGE: int

# Called when the node enters the scene tree for the first time.
func _ready():
	# Area3D of detection/attack
	# ----------------------------------
	AREA_DETECTION = $DetectionArea
	# warning-ignore:return_value_discarded
	AREA_DETECTION.connect("body_entered",Callable(self,"add_bodyInDetectionArea"))
	# warning-ignore:return_value_discarded
	AREA_DETECTION.connect("body_exited",Callable(self,"remove_bodyInDetectionArea"))
	
	AREA_ATTACK = $AttackArea
	# warning-ignore:return_value_discarded
	AREA_ATTACK.connect("body_entered",Callable(self,"add_bodyInAttackArea"))
	# warning-ignore:return_value_discarded
	AREA_ATTACK.connect("body_exited",Callable(self,"remove_bodyInAttackArea"))
	
	SPACE_ATTACK = $SpaceAttack
	# ----------------------------------
	
	# Animation & Audio
	# ----------------------------------
	zombieAnim	= $AnimationPlayer
#	charMoveState.set_active(true)
#	playerState	= UnequipItemState.new(self, audioPlayer, audioPlayerContinuous)
#	playerState.play_state()
	# ----------------------------------
	
	healthSystem = HealthSystem.new(100, 100)
	# warning-ignore:return_value_discarded
	healthSystem.connect("isDead",Callable(self,"is_dead"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if bodyInAttackArea or zombieAnim.get_current_animation() == "attack":
		zombieVel = Vector3(0, 0, 0)
		#look_at(bodyInAttackArea.global_transform.origin, Vector3(0, 1, 0))
		if zombieAnim.get_current_animation() != "attack":
			zombieAnim.play("attack");
	elif bodyInDetectionArea:
		look_at(bodyInDetectionArea.global_transform.origin, Vector3(0, 1, 0))
		zombieAnim.play("chase")
		zombieVel = zombieVel.lerp(-global_transform.basis.z * MAX_SPEED, delta * ACCEL)
	else:
		zombieVel = Vector3(0, 0, 0)
		zombieAnim.play("idle")
	
	set_velocity(zombieVel)
	set_up_direction(Vector3(0, 1, 0))
	move_and_slide()
	zombieVel = velocity

func add_bodyInDetectionArea(player):
	bodyInDetectionArea = player

func remove_bodyInDetectionArea(player):
	if bodyInDetectionArea == player:
		bodyInDetectionArea = null

func add_bodyInAttackArea(player):
	bodyInAttackArea = player

func remove_bodyInAttackArea(player):
	if bodyInAttackArea == player:
		bodyInAttackArea = null

func attack():
	var bodies = SPACE_ATTACK.get_overlapping_bodies()
	for body in bodies:
		if body is Character:
			body.healthSystem.take_damage(DAMAGE)

func is_dead():
	queue_free()
