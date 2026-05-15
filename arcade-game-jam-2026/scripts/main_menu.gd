extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var score := 0

const BAD := 200
const NOT_BAD := 2000
const GREAT := 10000

func _ready() -> void:
	score = get_parent().session_score
	$"Menu/Score".text = ("%06d" % [score])
	if get_parent().player_lives >=1:
		$Menu/MeanWords.text = "SCRAMBLE!"
		$Menu/FinalScore.text = " PRESS <1> TO BEGIN!"
		$Menu/Score.text = ""
		$MenuTheme.stop()
		#set first time menu theme
	elif score <= BAD:
		animation_player.current_animation = "appear"
		animation_player.play()
	elif score <= NOT_BAD:
		animation_player.current_animation = "appear_not_bad"
		animation_player.play()
	elif score <= GREAT:
		animation_player.current_animation = "appear_good_score"
		animation_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Menu/MeanWords.text = "PRESS 1 TO RESTART"
	$Menu/MeanWords.label_settings.font_size = 32

func player_2():
	var prev_text : String = $Menu/MeanWords.text
	var prev_size : int = $Menu/MeanWords.label_settings.font_size
	$NoMultiplayer.play()
	$Menu/MeanWords.text = "MAYBE NEXT YEAR"
	$Menu/MeanWords.label_settings.font_size = 32
	$DisplayTimer.start()
	create_tween().tween_property($Menu/MeanWords, "modulate:a",.01, .05)
	create_tween().tween_property($Menu/MeanWords, "modulate:a", 1, .05)
	await $DisplayTimer.timeout
	$Menu/MeanWords.text = prev_text
	$Menu/MeanWords.label_settings.font_size = prev_size
	return
