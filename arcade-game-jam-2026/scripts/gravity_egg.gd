extends RigidBody2D

@export var score := 75

var falling := true

func _ready() -> void:
	$AnimatedSprite2D.play("fall")
	linear_velocity.y = .011
	gravity_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if linear_velocity.y <= 0.01 and falling == false:
		score = 25
		$AnimatedSprite2D.play("splat")
		linear_velocity.y = 0
	elif linear_velocity.y <= 0.1:
		falling = false
		
