extends Marker2D

const DASH_SCENE = preload("res://dash.tscn")

@onready var dash_sound: AudioStreamPlayer2D = $DashSound

# Called when the node enters the scene tree for the first time.
func dash(direction: float = 1.0) -> bool:
	var dashfx := DASH_SCENE.instantiate()
	if direction == 1:
		dashfx.get_node("Plume").flip_h = direction
	dashfx.global_position = Vector2(global_position.x + (direction * 4), global_position.y)
	
	dashfx.set_as_top_level(true)
	add_child(dashfx)
	dash_sound.play()
	return true
	
