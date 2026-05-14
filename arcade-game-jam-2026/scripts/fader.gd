extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready():
	pass

func fade_in():
	$FaderTimer.start()
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
func fade_out():
	$FaderTimer.start()
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
