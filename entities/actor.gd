class_name Actor extends CharacterBody2D

signal collided(collision: KinematicCollision2D)

@onready var start_position = position

func _physics_process(delta):
	var collision_info: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision_info:
		_on_collision(collision_info)
		move_and_collide(velocity * delta)

func _on_collision(collision_info: KinematicCollision2D):
	collided.emit(collision_info)
	
func reset():
	position = start_position


