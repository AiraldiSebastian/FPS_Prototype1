extends KinematicBody

export var speed = 200
var space_state
var target

func _ready():
	space_state = get_world().direct_space_state

func _physics_process(delta):
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Player"):
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)


func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	move_and_slide(direction * speed * delta, Vector3.UP)


func _on_Area_body_entered(body):
		if body.is_in_group("Player") and body is KinematicBody:
			print(body.name + "entered")
			target = body
		


func _on_Area_body_exited(body):
	if body.is_in_group("Player") and body is KinematicBody:
		print(body.name + "exited")
		target = null
		
		
