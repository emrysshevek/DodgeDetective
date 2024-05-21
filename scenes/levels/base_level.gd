class_name BaseLevel extends Node2D

@onready var StartText: Control = get_node("UI/StartingText")
@onready var EndText: Control = get_node("UI/EndingText")
@onready var Entities: Node2D = get_node("Actors")
@onready var player: Player = get_node("Actors/Player")
@onready var ReplayNode: Replay = get_node("Replay")
@onready var Camera: LevelCamera = get_node("LevelCamera")

var running = false
var complete = false
var mode = "live"

func _ready():
	print("READY")
	player.hit.connect(reset_level)
	reset_level()
	
func _input(event):
	if !running && !complete && event.is_pressed():
		start_level()
	if !running && complete && event.is_pressed():
		next_level()

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_debug"):
		if mode == "live":
			mode = "replay"
			for entity in get_node("Actors").get_children():
				entity.show()
				entity.replay_mode()
			ReplayNode.replay()
			Camera.set_mode(mode)
		else:
			mode = "live"
			Engine.time_scale = 0
			for entity in get_node("Actors").get_children():
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
			entity.hide()
		if entity is Player:
			entity.is_bullet_time = false
	Engine.time_scale = .01
	ReplayNode.pause()
	
func next_level():
	pass

func reset_level():
	print("READY")
	Engine.time_scale = .01
	StartText.show()
	EndText.hide()
	Camera.set_mode("live")
	running = false
	for actor in Entities.get_children():
		actor.reset()

func on_player_entered_end():
	end_level()
