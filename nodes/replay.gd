class_name Replay

extends Node

var curr_time = 0.0
var mode = "record"
var states = []


func _physics_process(delta):
	curr_time += delta

func update_state(key, val):
	if states[states.size()-1].time != curr_time:
		var state = {
			"time": curr_time,
			"key": val
		}
		states.push_back(state)
	else:
		states[states.size()-1][key] = val

#func add_collision(collision)
		
