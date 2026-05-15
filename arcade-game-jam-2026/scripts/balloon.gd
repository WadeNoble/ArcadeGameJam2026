extends CharacterBody2D

const EXPLOSION = preload("res://explosion.tscn")
const FALL_EGG = preload("res://gravity_egg.tscn")
@onready var sprite: AnimatedSprite2D = $Sprite

const BOUNCE_IMPULSE = -100

var death_spot := Vector2.ZERO
var bouncing := false
var health := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation = "fall"
	add_to_group("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()*.5 * delta
	
	if is_on_floor():
		if bouncing == false:
			sprite.animation = "bounce"
			sprite.play()
			bouncing = true
			velocity.y = BOUNCE_IMPULSE
		else:
			$CollisionShape2D.set_deferred("disabled", true)
			sprite.animation = "fall"
			sprite.play()
			
	move_and_slide()


	
func explode():
	$Hurtbox.set_deferred("disabled", true)
	$Hitbox.set_deferred("disabled", true)
	var splode := EXPLOSION.instantiate()
	splode.global_position = global_position
	death_spot = splode.global_position
	get_parent().add_sibling(splode)
	sprite.hide()
	await splode.animation_finished
	score()
	queue_free()

func score():
	var egg := FALL_EGG.instantiate()
	egg.global_position = death_spot
	add_sibling(egg)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_projectiles"):
		body.destroy()
		#placeholder color, fix this later
		#$AnimationPlayer.play("flash") if want to add health
		health -= 1
		if body.name == "DashEffect":
			health -= 1
		$OofSound.play()
		#$FlashTimer.start() - want visual logic for reduced health - could just make new sprite
		if health <= 0:
			hide()

func _on_screen_exited() -> void:
	print("Goodbye! " + str(position.y))
	if position.y >= 360:
		queue_free()
	else:
		explode()
