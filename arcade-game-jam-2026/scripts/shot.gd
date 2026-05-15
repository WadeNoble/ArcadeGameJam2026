extends RigidBody2D

@export var damage := 1

func destroy() -> void:
	queue_free()
