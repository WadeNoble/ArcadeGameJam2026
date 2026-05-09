extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var shooter: Marker2D = $AnimatedSprite2D/Shooter

signal eggs_collected()
signal egg_collected()

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const FASTFALL_SPEED = 300

var has_double_jump := false


func _physics_process(delta: float) -> void:
	# Handle jumping. Return double jump if grounded
	if is_on_floor():
		has_double_jump = true
	if Input.is_action_just_pressed("Jump"):
		try_jump()
	elif Input.is_action_just_released("Jump") and velocity.y < 0.0:
		# The player let go of jump early, reduce vertical momentum.
		velocity.y *= 0.5
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y <= FASTFALL_SPEED:
			velocity += get_gravity() * delta
		else:
			velocity.y = FASTFALL_SPEED
		animated_sprite_2d.animation = "jump"


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	#Handle animation
	if velocity.x != 0:
		animated_sprite_2d.animation = "walk"
	else:
		animated_sprite_2d.animation = "idle"
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

func try_jump():
	if is_on_floor():
		jump_sound.pitch_scale = 1.0
	elif has_double_jump:
		has_double_jump = false
		velocity.x *= .9
		#change this to seperate sound later
		jump_sound.pitch_scale = 1.2
	else:
		return
	velocity.y = JUMP_VELOCITY
	jump_sound.play()
