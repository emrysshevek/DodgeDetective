extends Node

@export var min_speed = 10.0
@export var max_speed = 100.0
@export var initial_velocity: Vector2 = Vector2.ZERO
@export var acceleration = 40.0

@onready var velocity: Vector2 = initial_velocity

func _aim_at(position: Vector2, delta):
	var curr_speed = velocity.length()
	

func accelerate_toward(position: Vector2):
	velocity
