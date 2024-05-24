class_name LevelManager extends Node

var curr_level: Vector2i = Vector2i(0, 0)

var all_levels = [
	# set 1 levels
	[
		preload("res://scenes/levels/set1/1_1/level1_1.tscn"),
		preload("res://scenes/levels/set1/1_2/level1_2.tscn")
	],
	# set 2 levels
]

func get_level(set_val, num):
	curr_level = Vector2i(set_val-1, num-1)
	return all_levels[curr_level.x][curr_level.y]
