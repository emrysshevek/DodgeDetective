class_name BaseLevel extends Node2D

#@onready var StartText: Control = get_node("UI/MarginContainer/StartingText")
#@onready var EndText: Control = get_node("UI/MarginContainer/EndingText")
@onready var Actors: Node2D = get_node("Actors")
@onready var player: Player = get_node("Actors/Player")
@onready var ReplayNode: Replay = get_node("Replay")
@onready var Camera: LevelCamera = get_node("LevelCamera")
@onready var Map: BaseMap = get_node("MapContainer").get_child(0)
@onready var ui: LevelUI = get_node("LevelUI")
@onready var end_timer: Timer = get_node("Timers/EndTimer")

@export var level_name: String
@export var NextLevel: PackedScene

var running = false
var complete = false
var mode = "live"

func _ready():
	print("READY")
	# set up player
	player.hit.connect(reset_level)
	
	# set up map
	Map.player_entered_end.connect(end_level)
	
	# set up camera
	Camera.player = player
	Camera.level = Map
	
	#set up ui
	ui.pause_menu.resume.connect(resume_level)
	ui.pause_menu.restart.connect(reset_level)
	ui.set_level_name(level_name)
	
	# set up replay
	ReplayNode.Entities = Actors
	# TODO: connect replaynode's finished signal to do something when replay ends
	load_level()
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause_level()
	if !running && !complete && event.is_pressed():
		start_level()
	if !running && complete && event.is_pressed():
		next_level()

func _physics_process(delta):
	if Input.is_action_just_pressed("next") && complete:
		get_tree().change_scene_to_packed(NextLevel)
		
	if Input.is_action_just_pressed("reset_debug"):
		if mode == "live":
			mode = "replay"
			for entity in get_node("Actors").get_children():
				entity.show()
				entity.replay_mode()
			ReplayNode.start_replay()
			Camera.set_mode(mode)
		else:
			mode = "live"
			Engine.time_scale = 0
			for entity in get_node("Actors").get_children():
				entity.reset()
				entity.show()
			ReplayNode.record()
			
		Engine.time_scale = 1
		
func load_level():
	for actor: Actor in Actors.get_children():
		actor.reset()
	ui.show_start()
	Engine.time_scale = 0.005
	mode = "live"
	Camera.set_mode(mode)
	# reset timers and deaths
	ReplayNode.reset()
	
func start_level():
	running = true
	complete = false
	ui.hide_all()
	Engine.time_scale = 1
	ReplayNode.start_record()

func end_level():
	print("Performing end of level tasks")
	running = false
	complete = true
	ui.show_end()
	for entity in Actors.get_children():
		if entity is Enemy:
			entity.hide()
		if entity is Player:
			if entity.is_bullet_time:
				entity.toggle_bullet_time()
	Engine.time_scale = .01
	ReplayNode.pause()
	end_timer.start()

func play_ending_replay():
	print("Starting end of level replay")
	for actor in Actors.get_children():
		actor.replay_mode()
	Camera.set_mode("replay")
	ReplayNode.start_replay()
	Engine.time_scale = 1
	
func pause_level():
	Engine.time_scale = 0
	ui.show_pause()
	ReplayNode.pause()
	
func resume_level():
	Engine.time_scale = 1
	ui.hide_all()
	ReplayNode.resume()
	
func next_level():
	pass

func reset_level():
	print("READY")
	Engine.time_scale = .01
	ui.show_start()
	Camera.set_mode("live")
	running = false
	for actor in Actors.get_children():
		actor.reset()

func on_player_entered_end():
	end_level()

