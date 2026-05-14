extends CanvasLayer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Start"):
		_on_close_button_pressed()

func _on_pause_button_pressed():
	get_tree().paused = true
	show()

func _on_close_button_pressed():
	hide()
	get_tree().paused = false
