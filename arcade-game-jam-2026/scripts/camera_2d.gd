extends Camera2D

@export var speed = 400

func _process(delta):
	position.x += speed * delta
