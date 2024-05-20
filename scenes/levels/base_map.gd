class_name BaseMap extends TileMap

signal player_entered_arena
signal player_entered_end

var in_arena = false
var in_start = true
var in_end = false


func _on_start_area_body_entered(body):
	print(body, " ", body.position)
	if body is Player:
		print("player entered start")
		in_start = true

func _on_start_area_body_exited(body):
	print(body, " ", body.position)
	if body is Player:
		print("player left start")
		in_start = false

func _on_arena_area_body_entered(body):
	print(body, " ", body.position)
	if body is Player:
		print("player entered arena")
		in_arena = true
		player_entered_arena.emit()

func _on_arena_area_body_exited(body):
	print(body, " ", body.position)
	if body is Player:
		print("player left arena")
		in_arena = false
		if in_end:
			print("player finished level")
			player_entered_end.emit()

func _on_end_area_body_entered(body):
	print(body, " ", body.position)
	if body is Player:
		print("player entered end")
		in_end = true
		if in_arena == false:
			player_entered_end.emit()

func _on_end_area_body_exited(body):
	print(body, " ", body.position)
	if body is Player:
		print("player left end")
		in_end = false
