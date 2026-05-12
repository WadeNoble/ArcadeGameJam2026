extends Camera2D

@export var speed = 25

func _process(delta):
	position.x += speed * delta
