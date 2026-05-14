extends RigidBody2D

const EXPLOSION = preload("res://explosion.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func explode():
	#having another one of these is bad practice, especially with two preloads
	#but I broke the logic in Player and this is the easiest way to fix it
	var splode := EXPLOSION.instantiate()
	var parent := get_parent()
	splode.position = global_position
	parent.add_sibling(splode)
	queue_free()
