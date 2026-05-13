extends CharacterBody2D

@onready var shot_endlag: Timer = $ShotEndlag
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var death_timer: Timer = $DeathTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var eat_sound: AudioStreamPlayer2D = $EatSound
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var shooter: Marker2D = $AnimatedSprite2D/Shooter
@onready var dasher: Marker2D = $AnimatedSprite2D/Dasher
@onready var duster: Marker2D = $AnimatedSprite2D/Duster
@onready var label: Label = $Label
@onready var hurtbox_shape: CollisionShape2D = $Hurtbox/HurtboxShape
#@onready var ray_cast_2d: RayCast2D = $RayCast2D

#var screen_size

signal eggs_collected()
signal egg_collected()
signal died()
signal game_over()

const WALK_SPEED := 150.0
const BOOST_SPEED := 400.0
const FRICTION := 600.0
const JUMP_VELOCITY := -300.0
const FASTFALL_SPEED := 300
const DECELERATION := 50

#var current_speed := 0
var has_double_jump := false
var has_airdash := false
var airdashing := false
var has_coyote_time := false
var hard_landing := false
var is_dying := false
var lives := 3

func _ready():
	lives = lives

func _physics_process(delta: float) -> void:
	# Handle jumping. Recharge double jump if grounded
	label.text = str(lives)
	#if lives == 0:
		#game_over
	label.text = str(lives) + " " + str(int(death_timer.time_left))
	if death_timer.time_left != 0:
		label.text = str(lives) + " " + str(int(death_timer.time_left))
	elif is_dying == true:
		is_dying = false
		jump_sound.play()
		hurtbox_shape.set_deferred("disabled", false)
		
	if is_on_floor():
		if hard_landing:
			duster.dust()
			hard_landing = false
		has_double_jump = true
		has_airdash = true
		airdashing = false
		if not coyote_timer.is_stopped():
			coyote_timer.stop()
		has_coyote_time = true
		
	if Input.is_action_pressed("Down") and is_on_floor():
		#ray_cast_2d.enabled = true
		#if ray_cast_2d.is_colliding() == true:
			position.y += 3
	#else:
		#ray_cast_2d.enabled = false
		
	if Input.is_action_just_pressed("Jump"):
		try_jump()
	elif Input.is_action_just_released("Jump") and velocity.y < 0.0:
		#Hold-length dependent jump height
		velocity.y *= 0.5
	if Input.is_action_just_pressed("Dash Down Left") or Input.is_action_just_pressed("Dash Down Right"):
		try_airdash()
	
	# Add the gravity.
	if not is_on_floor():
		if has_coyote_time:
			if coyote_timer.is_stopped():
				coyote_timer.start()
			
		velocity.y = minf(FASTFALL_SPEED, velocity.y + get_gravity().y * delta)
		if velocity.y == FASTFALL_SPEED:
			hard_landing = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		#if airdash opposite way you're moving
		if airdashing and (velocity.x/direction == -1):
			velocity.x = move_toward(velocity.x, direction * WALK_SPEED, FRICTION*delta)
		#if airdash in direction you're moving
		elif (velocity.x * direction > WALK_SPEED):
			velocity.x = move_toward(velocity.x, direction * WALK_SPEED, FRICTION*delta*.2)
		#if have airdash speed and try to move opposite direction/are grounded
		elif (velocity.x * direction < -WALK_SPEED):
			velocity.x = move_toward(velocity.x, direction * WALK_SPEED, FRICTION*delta*5)
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
	if Input.is_action_pressed("Shoot Left"):
		is_shooting = shooter.shoot(-1)
	elif Input.is_action_pressed("Shoot Right"):
		is_shooting = shooter.shoot(1)
		
	if shot_endlag.is_stopped():
		if is_shooting:
			shot_endlag.start()
	
	
	#global_position = global_position.clamp(Vector2.ZERO, screen_size)	
	
#func _on_body_entered(body: Node) -> void:
	#die()
	
func get_new_animation():
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.animation = "walk"
		else:
			animated_sprite_2d.animation = "idle"
	else:
		if has_coyote_time:
			animated_sprite_2d.animation = "idle"
		elif has_double_jump:
			animated_sprite_2d.animation = "jump"
		else:
			animated_sprite_2d.animation = "jump2"

func try_jump():
	if is_on_floor() or has_coyote_time:
		jump_sound.pitch_scale = 1.0
		has_coyote_time = false
	elif has_double_jump:
		has_double_jump = false
		velocity.x *= .9
		#change this later
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
			dasher.dash(-1)
		elif Input.is_action_pressed("Dash Down Right"):
			velocity.x = BOOST_SPEED
			dasher.dash(1)
	else:
		return
	if not is_on_floor():
			velocity.y = FASTFALL_SPEED
			
func freefall():
	has_coyote_time = false

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		hit_sound.pitch_scale = 1
		hit_sound.play() #change to a better death sound
		die()
	else:
		hit_sound.pitch_scale = .4
		hit_sound.play()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	hit_sound.pitch_scale = 2
	hit_sound.play()#change to fall out sound
	die()
	
func die():
	lives -= 1
	if is_dying:
		return
	animated_sprite_2d.play("explode")
	#respawn timer?
	death_timer.start()
	is_dying = true
	died.emit()
	hurtbox_shape.set_deferred("disabled", true)
	position.y = 0
