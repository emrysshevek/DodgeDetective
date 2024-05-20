class_name ReflectorComponent extends Node

func reflect(actor: Actor, collision: KinematicCollision2D):
	actor.velocity = actor.velocity.bounce(collision.get_normal()).round()
	
