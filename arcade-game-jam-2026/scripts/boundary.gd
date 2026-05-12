extends StaticBody2D

@export var speed = 25

func _process(delta):
	position.x += speed * delta

func follow_cam():
	#speed = cam_speed
	pass
