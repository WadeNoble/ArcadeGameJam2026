extends RigidBody2D

func destroy() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player_projectiles"):
		body.destroy()
