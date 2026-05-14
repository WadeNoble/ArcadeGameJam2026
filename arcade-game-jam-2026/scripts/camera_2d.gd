extends Camera2D

@export var seeker_scene: PackedScene
const BIRD = preload("res://bird.tscn")

@export var speed := 25

@onready var seeker_timer: Timer = $SeekerTimer

func _process(delta):
	position.x += speed * delta
	print("Camera Position ", position.x)

func _on_seeker_timer_timeout() -> void:
	#instantiate a randomly spawning, horizontally flying enemy
	var bird = BIRD.instantiate()
	#add to scene tree
	bird.position = Vector2(position.x + 100,position.y)# - (180*randf()))
	print("Seeker Position 1 ", bird.position)
	add_child(bird)
		#set actual position to that of spawn location
	print(bird.position)
	return
