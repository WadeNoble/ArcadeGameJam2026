extends Marker2D
#Handles the "shooting" function of the player character.

const SHOT_VELOCITY = 700 

const SHOT_SCENE = preload("res://shot.tscn")

@onready var kick_sound: AudioStreamPlayer2D = $KickSound
@onready var delay_timer: Timer = $Cooldown

# Called when the node enters the scene tree for the first time.
func shoot(direction: float = 1.0) -> bool:
	if not delay_timer.is_stopped():
		return false
	var shot := SHOT_SCENE.instantiate()
	if direction == -1:
		shot.get_node("Foot").flip_h = direction
	shot.global_position = Vector2(global_position.x + (direction * 16), global_position.y)
	shot.linear_velocity = Vector2(direction * SHOT_VELOCITY, 0.0)

	shot.set_as_top_level(true)
	add_child(shot)
	kick_sound.play()
	delay_timer.start()
	return true
