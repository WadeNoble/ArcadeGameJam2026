extends Camera2D

@export var seeker_scene: PackedScene

@export var speed := 25

@onready var seeker_timer: Timer = $SeekerTimer

func _process(delta):
	position.x += speed * delta
	print("Camera Position ", position.x)

func _on_seeker_timer_timeout() -> void:
	#instantiate a randomly spawning, horizontally flying enemy
	var seeker = seeker_scene.instantiate()
	#add to scene tree
	seeker.position = Vector2(position.x + 100,position.y - (180*randf()))
	print("Seeker Position 1 ", seeker.position)
	add_child(seeker)
		#set actual position to that of spawn location
	print(seeker.position)
	return
