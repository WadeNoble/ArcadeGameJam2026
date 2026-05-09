extends Marker2D
#Handles the "shooting" function of the player character.

const SHOT_VELOCITY = 700
const SHOT_SCENE = preload("res://shot.tscn")
@onready var shooting_sfx: AudioStreamPlayer2D = $Shooting
@onready var delay_timer: Timer = $Cooldown

# Called when the node enters the scene tree for the first time.
func shoot(direction: float = 1.0) -> bool:
	if not delay_timer.is_stopped():
		return false
	var shot := SHOT_SCENE.instantiate()
	shot.global_position = global_position
	shot.linear_velocity = Vector2(direction * SHOT_VELOCITY, 0.0)

	shot.set_as_top_level(true)
	add_child(shot)
	shooting_sfx.play()
	delay_timer.start()
	return true
