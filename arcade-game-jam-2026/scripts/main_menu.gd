extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var score := 0

const BAD := 200
const NOT_BAD := 2000
const GREAT := 10000

func _ready() -> void:
	score = get_parent().session_score
	$"Menu/Score".text = ("%06d" % [score])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if score <= BAD:
		animation_player.current_animation = "appear"
		animation_player.play()
	elif score <= NOT_BAD:
		animation_player.current_animation = "appear_not_bad"
		animation_player.play()
	elif score <= GREAT:
		animation_player.current_animation = "appear_good_score"
		animation_player.play()
		
	if !animation_player.is_playing():
		animation_player.play("RESET")
	if Input.is_action_just_pressed("Jump"):
		get_tree().quit()
