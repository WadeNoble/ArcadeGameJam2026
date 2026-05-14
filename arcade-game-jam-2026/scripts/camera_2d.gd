extends Camera2D

@export var seeker_scene: PackedScene
const BIRD = preload("res://bird.tscn")

@export var speed := 25

@onready var seeker_timer: Timer = $SeekerTimer

func _process(delta):
	position.x += speed * delta

func _on_seeker_timer_timeout() -> void:
	#instantiate a randomly spawning, horizontally flying enemy
	var bird = BIRD.instantiate()
	#add to scene tree1
	bird.global_position = Vector2(global_position.x + 330, 45 + (215*randf()))
	print("Camera Position ", position.x, " ", position.y)
	print("Seeker Position 1 ", bird.position, bird.global_position)
	add_sibling(bird)
		#set actual position to that of spawn location
	print(bird.position)
