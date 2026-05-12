extends Marker2D

const DUST_SCENE = preload("res://dust.tscn")

func dust():
	var dust := DUST_SCENE.instantiate()
	dust.global_position = Vector2(global_position.x, global_position.y)
	
	dust.set_as_top_level(true)
	add_child(dust)
	return true
