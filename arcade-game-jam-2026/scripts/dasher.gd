extends Marker2D

const DASH_SCENE = preload("res://dash.tscn")

@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var delay_timer: Timer = $DashCooldown

# Called when the node enters the scene tree for the first time.
func dash(direction: float = 1.0) -> bool:
	if not delay_timer.is_stopped():
		return false
	var dashfx := DASH_SCENE.instantiate()
	if direction == 1:
		dashfx.get_node("Plume").flip_h = direction
	dashfx.position.x = position.x - (direction*12)
	
	add_child(dashfx)
	dash_sound.play()
	delay_timer.start()
	return true
	
