class_name Actor extends CharacterBody2D

signal collided(collision: KinematicCollision2D)

@onready var start_position = position

var controllable = true

func _ready():
	controllable = true
	start_position = position

func _physics_process(delta):
	if controllable:
		var collision_info: KinematicCollision2D = move_and_collide(velocity * delta)
		if collision_info:
			_on_collision(collision_info)
			move_and_collide(velocity * delta)
	
func _on_collision(collision_info: KinematicCollision2D):
	collided.emit(collision_info)
	
func reset():
	show()
	controllable = true
	position = start_position
	
func replay_mode():
	reset()
	controllable = false
	
func disable_movement():
	controllable = false

func die():
	hide()
