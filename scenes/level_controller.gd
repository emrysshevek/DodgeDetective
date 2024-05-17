extends Node2D

@onready var StartText: Control = get_node("UI/Control/StartingText")
@onready var EndText: Control = get_node("UI/Control/EndingText")
@onready var Entities: Node2D = get_node("Entities")

var running = false


func _ready():
	print("READY")
	Engine.time_scale = .01
	StartText.show()
	EndText.hide()
	
func _input(event):
	if !running && event.is_pressed():
		start_level()

func _physics_process(delta):
	if Input.is_action_just_pressed("reset_debug"):
		Engine.time_scale = 0
		for entity in get_node("Entities").get_children():
			entity.reset()
		Engine.time_scale = 1
	#print("NEW FRAME")
	
func start_level():
	running = true
	StartText.hide()
	Engine.time_scale = 1

func end_level():
	running = false
	EndText.show()
	Engine.time_scale = .01
	for entity in Entities.get_children():
		if entity is Enemy:
			entity.queue_free()

func _on_body_exited_level_area(body):
	print(typeof(body), "exited the level")
	if body is Player:
		end_level()
