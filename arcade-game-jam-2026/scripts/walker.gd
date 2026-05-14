extends CharacterBody2D

const EXPLOSION = preload("res://explosion.tscn")
const EGG = preload("res://egg.tscn")

var speed = 100
var direction = -1
var health = 2
var death_spot := Vector2(0,0)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

#var is_alive = true

func _ready():
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	#should never leave the platform, but just in case
	#if $FlashTimer.is_stopped():
		#show()
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not ray_cast_2d.is_colliding() and is_on_floor():
		turn()

	velocity.x = speed * direction

	update_animation()
	move_and_slide()

func update_animation():
	animated_sprite_2d.play("walk")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_projectiles"):
		body.queue_free()
		#placeholder color, fix this later
		animated_sprite_2d.modulate -= Color(10,10,10,255)
		$AnimationPlayer.play("flash")
		health -= 1
		if body.name == "DashEffect":
			health -= 1
		$OofSound.play()
		#$FlashTimer.start() - want visual logic for reduced health - could just make new sprite
		if health <= 0:
			hide()
	
func turn():
	direction = -direction
	scale.x = scale.x * -1


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	show()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	explode()
	
func explode():
	$Hurtbox.set_deferred("disabled", true)
	var splode := EXPLOSION.instantiate()
	splode.global_position = global_position
	death_spot = splode.global_position
	get_parent().add_sibling(splode)
	hide()
	await splode.animation_finished
	score()
	queue_free()
	
	
func score():
	var egg := EGG.instantiate()
	egg.global_position = death_spot
	get_parent().add_sibling(egg)
	
