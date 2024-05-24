class_name LevelCamera extends Camera2D

@export var player: Player
@export var level: TileMap
var mode = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mode == "replay":
		position = lerp(position, player.position, delta * 10)


func set_mode(new_mode):
	if new_mode == mode:
		return
	
	mode = new_mode
	if mode == "live":
		position = level.get_used_rect().get_center() * level.tile_set.tile_size
		print(position)
		zoom = Vector2(1.0, 1.0)
	elif mode == "replay":
		zoom = Vector2(1.2, 1.2)
