extends Marker2D

const DUST_SCENE = preload("res://dust.tscn")

func dust():
	var dust := DUST_SCENE.instantiate()
	dust.global_position = global_position
	
	dust.set_as_top_level(true)
	add_child(dust)
	return true
