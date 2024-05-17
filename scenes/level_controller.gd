extends Node2D

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_debug"):
		Engine.time_scale = 0
		for entity in get_node("Entities").get_children():
			entity.reset()
		Engine.time_scale = 1
	print("NEW FRAME")
