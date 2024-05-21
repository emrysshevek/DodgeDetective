class_name Enemy extends Actor

@export var speed = 1000
@export var rotation_speed = 10

@onready var Sprite: Sprite2D = get_node("Sprite2D")
@onready var Emitter: CPUParticles2D = get_node("CPUParticles2D")
@onready var Reflector: ReflectorComponent = get_node("ReflectorComponent")

func _ready():
	reset()
	
func _process(delta):
	Sprite.rotation = Sprite.rotation + (rotation_speed * delta)
	if Sprite.rotation > 360:
		Sprite.rotation -= 360
		
	Emitter.direction = Vector2.DOWN
	Emitter.scale = scale * .5
		
func _on_collision(collision):
	super(collision)
	Reflector.reflect(self, collision)


func reset():
	super.reset()
	velocity = transform.y * speed
	Sprite.rotation = 0

func replay_mode():
	reset()
	velocity *= 0
