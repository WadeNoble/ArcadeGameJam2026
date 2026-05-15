extends Node

@export var level_scene: PackedScene

@onready var idle_timeout: Timer = $IdleTimeout
@onready var level_location:= "World/LevelLayer/LevelRoot"
@onready var main_menu_location:= "MainMenu"

var session_score := 0
var instance_dead := true
var player_lives := 3

func _ready():
	Fader.fade_in()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Force quit for machines	
	if Input.is_action_just_pressed("End"):
		ggs()
		
	if instance_dead == false:
		if get_node(level_location):
			session_score = get_node(level_location).total_score
			player_lives = get_node(level_location).get_node("Player").lives
			$HudCanvasLayer/HudRoot/LivesLabel.text = "x " + str(player_lives)
			$HudCanvasLayer/HudRoot/ScoreLabel.text = ("%06d" % session_score)
			$HudCanvasLayer/HudRoot/PlayTime.text = ("%04d" % get_node(level_location).time_played)
		else:
			$PauseCanvasLayer.hide()
			$HudCanvasLayer.hide()
			instance_dead = true
		
	if Input.is_action_just_pressed("Start"):
		if $"/root/Fader/FaderTimer".time_left > 0:
			return
		if !is_instance_valid(get_node(level_location)):
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
			instance_dead = false
		elif get_node(level_location).process_mode == PROCESS_MODE_INHERIT:
			$PauseCanvasLayer.show()
			get_node(level_location).process_mode = PROCESS_MODE_DISABLED
		elif get_node(level_location).process_mode == PROCESS_MODE_DISABLED:
			$PauseCanvasLayer.hide()
			get_node(level_location).process_mode = PROCESS_MODE_INHERIT
			
	if Input.is_action_just_pressed("Start2"):
		if instance_dead == true:
			if get_node(main_menu_location):
				get_node(main_menu_location).player_2()
		else:
			$HudCanvasLayer/HudRoot/Player2.text = "MAYBE NEXT YEAR"
			$NextYear.start()
			await $NextYear.timeout
			$HudCanvasLayer/HudRoot/Player2.text = ""
	
	if Input.is_anything_pressed():
		#print(180 - idle_timeout.time_left)
		idle_timeout.start()
		#show credits at 10 seconds left

func ggs():
	get_tree().quit()
	
