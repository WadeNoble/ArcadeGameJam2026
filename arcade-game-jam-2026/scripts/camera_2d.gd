extends Camera2D

@export var seeker_scene: PackedScene
const BIRD = preload("res://bird.tscn")
const BALLOON = preload("res://balloon.tscn")

@export var speed := 25

@onready var seeker_timer: Timer = $SeekerTimer

func _process(delta):
	position.x += speed * delta + ($"..".difficulty*.05)
func _on_seeker_timer_timeout() -> void:
	more_birds()
	more_balloons()

func more_birds():
	#instantiate a randomly spawning, horizontally flying enemy
	var bird = BIRD.instantiate()
	#add to scene tree
	if get_parent().difficulty <= 2:
		#normal birds
		bird.global_position = Vector2(global_position.x + 330, 45 + (215*randf()))
	elif get_parent().difficulty > 2:
		$Label.visible = !$Label.visible
		$Label.text = "MORE BIRDS"
		$DifficultyTimer.wait_time -= .05
		bird.global_position = Vector2(global_position.x + 330, $"../Player".position.y - 45 + (60*randf()))
	
	print("Camera Position ", position.x, " ", position.y)
	print("Bird Position 1 ", bird.position, bird.global_position)
	add_sibling(bird)
		#set actual position to that of spawn location
	print(bird.position)

func more_balloons():
	#instantiate a randomly spawning, horizontally flying enemy
	var balloon = BALLOON.instantiate()
	#add to scene tree
	if get_parent().difficulty <= 2:
		#normal balloons
		balloon.global_position = Vector2(global_position.x + 60 + (215*randf()), 0)
	elif get_parent().difficulty > 3:
		$Label.visible = !$Label.visible
		$Label.text = "MORE BALLOONS"
		$DifficultyTimer.wait_time -= .05
		balloon.global_position = Vector2($"../Player".position.x - 45 + (80*randf()), 0)
	
	print("Camera Position ", position.x, " ", position.y)
	print("Balloon Position 1 ", balloon.position, balloon.global_position)
	add_sibling(balloon)
		#set actual position to that of spawn location
	print(balloon.position)
