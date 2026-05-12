extends CharacterBody2D
@onready var shot_endlag: Timer = $ShotEndlag
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var shooter: Marker2D = $AnimatedSprite2D/Shooter

signal eggs_collected()
signal egg_collected()

const WALK_SPEED := 150.0
const BOOST_SPEED := 300.0
const FRICTION := 600.0
const JUMP_VELOCITY := -300.0
const FASTFALL_SPEED := 300
const DECELERATION := 50

var current_speed := 0
var has_double_jump := false
var has_airdash := false
var airdashing := false


func _physics_process(delta: float) -> void:
	# Handle jumping. Return double jump if grounded
	if is_on_floor():
		has_double_jump = true
		has_airdash = true
		airdashing = false
	if Input.is_action_just_pressed("Jump"):
		try_jump()
	elif Input.is_action_just_released("Jump") and velocity.y < 0.0:
		#Hold-length dependent jump height
		velocity.y *= 0.5
	if Input.is_action_just_pressed("Dash Down Left") or Input.is_action_just_pressed("Dash Down Right"):
		try_airdash()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y = minf(FASTFALL_SPEED, velocity.y + get_gravity().y * delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		if airdashing:
			pass
		elif (velocity.x * direction > WALK_SPEED):
			velocity.x = move_toward(velocity.x, direction * WALK_SPEED, FRICTION*delta*.5)
		else:
			velocity.x = direction * WALK_SPEED
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
		elif not is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION*delta*.5)

	move_and_slide()
	#Handle animation
	get_new_animation()
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

	var is_shooting := false
	if Input.is_action_just_pressed("Shoot Left"):
		is_shooting = shooter.shoot(-1)
	elif Input.is_action_just_pressed("Shoot Right"):
		is_shooting = shooter.shoot(1)
		
	if shot_endlag.is_stopped():
		if is_shooting:
			shot_endlag.start()
	
func get_new_animation():
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.animation = "walk"
		else:
			animated_sprite_2d.animation = "idle"
	else:
		if has_double_jump:
			animated_sprite_2d.animation = "jump"
		else:
			animated_sprite_2d.animation = "jump2"

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
	
func try_airdash():
	if has_airdash:
		has_airdash = false
		airdashing = true
		if Input.is_action_pressed("Dash Down Left"):
			velocity.x = -BOOST_SPEED
		elif Input.is_action_pressed("Dash Down Right"):
			velocity.x = BOOST_SPEED
	else:
		return
	if not is_on_floor():
			velocity.y = FASTFALL_SPEED
	dash_sound.play()
