extends RigidBody2D

@export var score := 75

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if linear_velocity.y == 0:
		score = 25
		$AnimatedSprite2D.play("splat")
		
