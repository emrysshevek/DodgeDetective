class_name Player extends CharacterBody2D

signal hit

@export var speed = 500
@export var bullet_time_scale = .01

@onready var Arrow: Node2D = get_node("DirectionArrow")
@onready var StepTimer: Timer = get_node("StepTimer")
@onready var frame = 0
@onready var start_position = position

var is_bullet_time = false
var in_step = false
var step_direction
var states = []
var mode = "live"

func reset():
	position = start_position
	is_bullet_time = false
	StepTimer.stop()
	in_step = false
	if mode == "live":
		mode = "replay"
	else:
		mode = "live"
	frame = 0

func _process(delta):
	Arrow.look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("bullet_time"):
		toggle_bullet_time()
		print("is_bullet_time: ", is_bullet_time)

func _physics_process(delta):
	if mode == "live":
		live_movement(delta)
	elif mode == "replay":
		replay_movement(delta)

func live_movement(delta):
	var direction
	var state: Dictionary = {}
	
	if in_step:
		direction = step_direction
	else:
		if is_bullet_time:
			if Input.is_action_just_released("step_direction"):
				begin_step(global_position.direction_to(get_viewport().get_mouse_position()))
			elif Input.is_action_just_pressed("step_still"):
				begin_step(null)
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_vector("left", "right", "up", "down")

	if direction:
		position += direction * speed * delta
		state["offset"] = direction * speed * delta
	
	if !state.is_empty():
		state["frame"] = frame
		states.push_back(state)

	frame += 1 * Engine.time_scale
	move_and_slide()

func replay_movement(delta):
	if states.size() > 0 && frame >= states[0].frame:
		var input_state: Dictionary = states.pop_front()
		if input_state.get("offset"):
			position += input_state.offset
	frame += 1

func _on_hit_box_body_entered(body):
	# check if body is an enemy
	# emit hit signal if true
	if body is Enemy:
		print("hit an enemy")
		var emitter = get_node("CPUParticles2D") as CPUParticles2D
		emitter.emitting = true
		hit.emit()

func toggle_bullet_time():
	is_bullet_time = !is_bullet_time
	if is_bullet_time:
		Arrow.show()
		Engine.time_scale = bullet_time_scale
	else:
		Arrow.hide()
		Engine.time_scale = 1

func begin_step(direction):
	print(direction)
	in_step = true
	step_direction = direction
	Engine.time_scale = 1
	StepTimer.start()

func end_step():
	in_step = false
	if is_bullet_time:
		Engine.time_scale = bullet_time_scale
