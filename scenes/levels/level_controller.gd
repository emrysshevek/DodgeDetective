extends Node2D

@onready var StartText: Control = get_node("UI/Control/StartingText")
@onready var EndText: Control = get_node("UI/Control/EndText")
@onready var Entities: Node2D = get_node("Entities")
@onready var EndArea: Area2D = get_node("EndArea")
@onready var ReplayNode: Replay = get_node("Replay")
@onready var Camera: LevelCamera = get_node("LevelCamera")

var running = false
var complete = false
var mode = "live"


func _ready():
	print("READY")
	Engine.time_scale = .01
	StartText.show()
	EndText.hide()
	Camera.player = get_node("Entities/Player")
	Camera.level = get_node("TileMap")
	Camera.set_mode("live")
	
	
func _input(event):
	if !running && !complete && event.is_pressed():
		start_level()

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_debug"):
		if mode == "live":
			mode = "replay"
			for entity in get_node("Entities").get_children():
				entity.show()
				entity.replay_mode()
			ReplayNode.replay()
			Camera.set_mode(mode)
		else:
			mode = "live"
			Engine.time_scale = 0
			for entity in get_node("Entities").get_children():
				entity.reset()
				entity.show()
			ReplayNode.record()
			
		Engine.time_scale = 1
	
func start_level():
	running = true
	complete = false
	StartText.hide()
	Engine.time_scale = 1
	ReplayNode.record()

func end_level():
	running = false
	complete = true
	EndText.show()
	for entity in Entities.get_children():
		if entity is Enemy:
			#entity.queue_free()
			entity.hide()
		if entity is Player:
			entity.is_bullet_time = false
	Engine.time_scale = .01
	ReplayNode.pause()

func _on_body_exited_level_area(body):
	print(typeof(body), "exited the level")
	if body is Player && EndArea.overlaps_body(body):
		end_level()
