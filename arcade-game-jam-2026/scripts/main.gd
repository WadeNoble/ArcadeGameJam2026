extends Node

@export var level_scene: PackedScene

@onready var idle_timeout: Timer = $IdleTimeout

var session_score := 0
var instance_dead := false
var player_lives := 3

func _ready():
	Fader.fade_in()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Force quit for machines	
	if Input.is_action_just_pressed("End"):
		ggs()
		
	if instance_dead == false:
		if $World/LevelLayer/LevelRoot:
			session_score = $World/LevelLayer/LevelRoot.total_score
			player_lives = $World/LevelLayer/LevelRoot/Player.lives
			$HudCanvasLayer/HudRoot/LivesLabel.text = "LIVES: " + str(player_lives)
			$HudCanvasLayer/HudRoot/ScoreLabel.text = ("%06d" % session_score)
		else:
			$PauseCanvasLayer.hide()
			$HudCanvasLayer.hide()
			instance_dead = true
		
	if Input.is_action_just_pressed("Start"):
		if !is_instance_valid($World/LevelLayer/LevelRoot):
			var begin_game = load("res://level/testlevel.tscn").instantiate()
			level_scene.instantiate()
			Fader.fade_out()
			await $"/root/Fader/FaderTimer".timeout
			if is_instance_valid($MainMenu):
				$MainMenu.queue_free()
			Fader.fade_in()
			$World/LevelLayer.add_child(begin_game)
			$HudCanvasLayer.show()
			await $"/root/Fader/FaderTimer".timeout
		elif $World/LevelLayer/LevelRoot.process_mode == PROCESS_MODE_INHERIT:
			$PauseCanvasLayer.show()
			$World/LevelLayer/LevelRoot.process_mode = PROCESS_MODE_DISABLED
		elif $World/LevelLayer/LevelRoot.process_mode == PROCESS_MODE_DISABLED:
			$PauseCanvasLayer.hide()
			$World/LevelLayer/LevelRoot.process_mode = PROCESS_MODE_INHERIT
			
	
	if Input.is_anything_pressed():
		#print(180 - idle_timeout.time_left)
		idle_timeout.start()
		#show credits at 10 seconds left

func ggs():
	get_tree().quit()
	
