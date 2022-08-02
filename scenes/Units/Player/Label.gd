extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_text("FPS: " + str(Engine.get_frames_per_second()) + "\nFramesDraw: " + str(Engine.get_frames_drawn()) + "\nFramesPhysics: " + str(Engine.get_physics_frames()))
