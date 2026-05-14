extends Node

@export var level_scene: PackedScene

@onready var idle_timeout: Timer = $IdleTimeout
@onready var level_root: Node2D = $World/LevelLayer/LevelRoot

var session_score := 0
#var player_lives := 3

func _ready():
	Fader.fade_in()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Force quit for machines
	if is_instance_valid(level_root):
		session_score = level_root.total_score
		print(session_score)
	else:
		pass
		
	if Input.is_action_just_pressed("End"):
		ggs()
		
	if Input.is_action_just_pressed("Start"):
		if !is_instance_valid(level_root):
			var begin_game = load("res://level/testlevel.tscn").instantiate()
			level_scene.instantiate()
			Fader.fade_out()
			Fader.FaderTimer.start()
			
			$World/LevelLayer.add_child(begin_game)
		elif level_root.process_mode == PROCESS_MODE_INHERIT:
			$PauseCanvasLayer.show()
			level_root.process_mode = PROCESS_MODE_DISABLED
		elif level_root.process_mode == PROCESS_MODE_DISABLED:
			$PauseCanvasLayer.hide()
			level_root.process_mode = PROCESS_MODE_INHERIT
			
	
	if Input.is_anything_pressed():
		#print(180 - idle_timeout.time_left)
		idle_timeout.start()
		#show credits at 10 seconds left

func ggs():
	get_tree().quit()
	
