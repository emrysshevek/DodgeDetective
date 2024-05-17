class_name Enemy

extends CharacterBody2D

@export var speed = 1000
@export var rotation_speed = 10

@onready var start_position = position
@onready var Sprite = get_node("Sprite2D")

func _ready():
	reset()
	
func _process(delta):
	Sprite.rotation = Sprite.rotation + (rotation_speed * delta)
	if Sprite.rotation > 360:
		Sprite.rotation -= 360

func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		print("Collision", position.round())
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal())
		move_and_collide(reflect)
	position = position.round()

func reset():
	position = start_position
	velocity = (Vector2.UP + Vector2.RIGHT) * speed
	Sprite.rotation = 0
