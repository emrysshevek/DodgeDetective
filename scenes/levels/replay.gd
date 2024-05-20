class_name Replay

extends Node

@export var Entities: Node2D

var curr_time = 0.0
var elapsed_time = 0.0
var ticks = 10.0 # number of ticks per second
var tick_length = 1 / ticks # duration between each tick
var mode = "record"
var paused = true
var states = []

func set_mode(new_mode):
	mode = new_mode
	curr_time = 0
	elapsed_time = 0
	
func record():
	states = []
	paused = false
	mode = "record"
	restart()

func replay():
	paused = false
	mode = "replay"
	restart()

func pause():
	paused = true

func resume():
	paused = false
	
func restart():
	curr_time = 0.0
	elapsed_time = 0.0

	
func _physics_process(delta):
	if paused:
		return
		
	if mode == "replay" && states.size() > 0:
		replay_state(delta)
		
	elapsed_time += delta * Engine.time_scale
	curr_time += delta * Engine.time_scale
	
	if elapsed_time >= tick_length:
		elapsed_time -= tick_length
		if mode == "record":
			save_state()
			#print("SAVING STATE @ %s. STATE COUNT = %s" % [curr_time, states.size()])
		elif states.size() > 0:
			states.pop_front()
			#print("REPLAYING STATE @ %s. STATE COUNT = %s" % [curr_time, states.size()])
			if states.size() == 0:
				pause()

func save_state():
	var state = []
	for entity in Entities.get_children():
		state.append([entity, entity.global_position])
	states.append(state)
	
func replay_state(delta):
	for kv in states[0]:
		var entity: Node2D = kv[0]
		var pos: Vector2 = kv[1]
		entity.global_position = entity.global_position.lerp(pos, elapsed_time / tick_length)
		#entity.global_position = pos
		
		
		
		
