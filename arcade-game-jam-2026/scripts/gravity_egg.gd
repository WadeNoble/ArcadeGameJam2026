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
		linear_velocity = Vector2.ZERO
	elif linear_velocity.y <= 0.1:
		falling = false
		if $DespawnTimer.is_stopped():
			$DespawnTimer.start()
	if $DespawnTimer.time_left <= 3 and not $DespawnTimer.is_stopped():
			create_tween().tween_property(self,"modulate:a",0.1,.5)
			create_tween().tween_property(self,"modulate:a",1.0,1)

func _on_despawn_timer_timeout() -> void:
	queue_free()
