extends RigidBody2D

const EXPLOSION = preload("res://explosion.tscn")

func explode():
	#having another one of these is bad practice, especially with two preloads
	#but I broke the logic in Player and this is the easiest way to fix it
	var splode := EXPLOSION.instantiate()
	splode.global_position = global_position
	get_parent().add_sibling(splode)
	queue_free()
