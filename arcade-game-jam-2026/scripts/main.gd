extends Node
@onready var idle_timeout: Timer = $IdleTimeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Force quit for machines
	if Input.is_action_just_pressed("End"):
		ggs()
	
	if Input.is_anything_pressed():
		#print(180 - idle_timeout.time_left)
		idle_timeout.start()
		
func ggs():
	get_tree().quit()
