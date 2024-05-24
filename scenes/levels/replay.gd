class_name Replay

extends Node

signal finished

@export var Entities: Node2D

var curr_time = 0.0
var elapsed_time = 0.0
var ticks = 30.0 # number of ticks per second
var tick_length = 1 / ticks # duration between each tick
var mode: String = "record"
var paused: bool = true
var reverse: bool = false
var states = []
var state_idx: int = 0

func start():
	reset()
	paused = false

func pause():
	paused = true
	
func resume():
	paused = false
	
func reset():
	if mode == "record":
		states = []
	else:
		if reverse:
			state_idx = states.size() - 1
		else:
			state_idx = 0
	curr_time = 0.0
	elapsed_time = 0.0
	
func set_mode(mode, reverse=false):
	self.mode = mode
	self.reverse = reverse
	if self.reverse:
		state_idx = -10
	
func start_record():
	set_mode("record")
	start()

func start_replay(reverse=false):
	set_mode("replay", reverse)
	start()
	
func _physics_process(delta):
	if paused:
		return
		
	elapsed_time += delta * Engine.time_scale
	curr_time += delta * Engine.time_scale
	var is_new_state = elapsed_time >= tick_length
	
	if is_new_state:
		elapsed_time -= tick_length
		
	if mode == "record":
		_record(is_new_state)
	elif mode == "replay":
		_replay(is_new_state)

func _record(is_new_state):
	if is_new_state:
		save_state()
	
func _replay(is_new_state):
	# start reverse replay if necessary
	if reverse && state_idx < -1:
		state_idx = states.size() - 1
	
	# update state index (-1 if reversed, +1 otherwise)
	if is_new_state:
		print("Replaying state %s @ %s" % [state_idx, curr_time])
		# if reverse is true, then reverse=>1 and -1^1=>-1
		# if reverse is false, then reverse=>0 and -1^0=>+1
		state_idx += pow(-1, reverse as int)
		if _replay_is_finished():
			finished.emit()
			pause()
	# play current state
	if !_replay_is_finished():
		replay_state()
	else:
		finished.emit()
		pause()

func _replay_is_finished():
	return (reverse && state_idx <= 0) || (!reverse && state_idx >= states.size() - 1)
	
func save_state():
	print("Saving state %s @ %s" % [states.size(), curr_time])
	var state = []
	for entity in Entities.get_children():
		state.append([entity, entity.global_position])
	states.append(state)
	
func replay_state():
	for kv in states[state_idx]:
		var entity: Node2D = kv[0]
		var pos: Vector2 = kv[1]
		entity.global_position = entity.global_position.lerp(pos, elapsed_time / tick_length)
		#entity.global_position = pos
		
		
		
		
