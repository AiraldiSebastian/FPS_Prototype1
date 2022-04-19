extends Node


#func process_animation(_delta):
##	Currently when player falls animation will not play, since Vectors have the Y-Axis set to 0
##	and when player falls Y-Axis is set to -1. We could set to test both cases if we want 
##	animations to keep playing whe player is fallin.
##
##	Method 1
##	------------------------------------------------------------------------------------------------
#	if playerCurrentItem:
#		if animationDir == Vector3(0, 0, 0) or animationDir == Vector3(0, -1, 0):
#			characterAnim.play("idle", 0.1)
##			if !perspectiveAnim.is_playing():
##				characterAnim.play("weapon_idle", 0.1)
##				perspectiveAnim.play("weapon_idle", 0.1)
#		if animationDir == Vector3(1, 0, 1):
#			characterAnim.play("left", 0.1)
#		if animationDir == Vector3(-1, 0, 1):
#			characterAnim.play("right", 0.1)
#		if animationDir == Vector3(1, 0, -1):
#			characterAnim.play("right", 0.1)
#		if animationDir == Vector3(-1, 0, -1):
#			characterAnim.play("left", 0.1)
#		if animationDir == Vector3(0, 0, 1):
#			characterAnim.play("forward", 0.1)
#		if animationDir == Vector3(0, 0, -1):
#			characterAnim.play_backwards("forward", 0.1)
#		if animationDir == Vector3(1, 0, 0):
#			characterAnim.play("left", 0.1)
#		if animationDir == Vector3(-1, 0, 0):
#			characterAnim.play("right", 0.1)
#	else:
#		if animationDir == Vector3(0, 0, 0) or animationDir == Vector3(0, -1, 0):
#			characterAnim.play("idle", 0.1)
#			perspectiveAnim.play("idle", 0.1)
#		if animationDir == Vector3(1, 0, 1):
#			characterAnim.play("left", 0.1)
#		if animationDir == Vector3(-1, 0, 1):
#			characterAnim.play("right", 0.1)
#		if animationDir == Vector3(1, 0, -1):
#			characterAnim.play("right", 0.1)
#		if animationDir == Vector3(-1, 0, -1):
#			characterAnim.play("left", 0.1)
#		if animationDir == Vector3(0, 0, 1):
#			characterAnim.play("forward", 0.1)
#		if animationDir == Vector3(0, 0, -1):
#			characterAnim.play_backwards("forward", 0.1)
#		if animationDir == Vector3(1, 0, 0):
#			characterAnim.play("left", 0.1)
#		if animationDir == Vector3(-1, 0, 0):
#			characterAnim.play("right", 0.1)
##	------------------------------------------------------------------------------------------------
