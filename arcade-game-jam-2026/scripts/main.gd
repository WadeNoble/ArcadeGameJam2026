extends Node

@export var level_scene: PackedScene

@onready var idle_timeout: Timer = $IdleTimeout
@onready var level_root: Node2D = $World/LevelLayer/LevelRoot

signal pause_pressed

var score := 0
var player_lives := 3

func _ready():
	$TestLabel.text = "Begin!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Force quit for machines
	if Input.is_action_just_pressed("End"):
		ggs()
		
	#if Input.is_action_just_pressed("Start"):
		#pause_pressed
		#arcade games don't need to pause!
	
	if Input.is_anything_pressed():
		#print(180 - idle_timeout.time_left)
		idle_timeout.start()
		#show credits at 10 seconds left




func ggs():
	get_tree().quit()
	
