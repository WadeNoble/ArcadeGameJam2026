extends StaticBody2D

@export var damage := 2

func destroy() -> void:
	await $Plume.animation_finished
	queue_free()

#func _on_body_entered(body: Node) -> void:
#	if body is Enemy:
#		(body as Enemy).destroy()
