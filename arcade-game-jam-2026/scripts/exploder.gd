extends Marker2D

const EXPLODE = preload("res://explosion.tscn")

func explode():
	var explosion := EXPLODE.instantiate()
	explosion.global_position = global_position
	
	explosion.top_level = true
	add_child(explosion)
	return true
