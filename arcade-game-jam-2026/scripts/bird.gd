extends Node2D

const EXPLOSION = preload("res://explosion.tscn")
const GRAVITY_EGG = preload("res://gravity_egg.tscn")

@onready var animation_player: AnimationPlayer = $Bird/AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $Bird/AnimatedSprite2D
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $Bird/VisibleOnScreenEnabler2D

@export var health := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("flap")
	if get_parent().difficulty > 5:
		health += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	animation_player.play("fly")
	#can try adding non-straight flight patterns - sin() is an option
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if position.x + 40 <= get_parent().get_node("Camera").position.x:
		queue_free()
	else:
		print("Birdpos", str(position.x), " Birdglob,", str(global_position.x) ,"TestCamera position ", str(get_parent().get_node("Camera").position.x))
		explode()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_projectiles"):
		body.destroy()
		health -= body.damage
		if health <= 0:
			hide()
		else:
			$HitSound.play()
			var alpha_tween := create_tween()
			alpha_tween.tween_property(animated_sprite_2d, "modulate:a", 0.01, 0.05) # Fade out over 0.1s
			alpha_tween.tween_property(animated_sprite_2d, "modulate:a", 1.0, 0.05) # Fade in over 0.1s
			#var bird_time = animation_player.current_animation_position
			#animation_player.current_animation = "flash"
			#animation_player.play()
			#await animation_player.animation_finished
			#animated_sprite_2d.visible = false
			#animation_player.current_animation = "fly"
			#animation_player.seek(bird_time)
			#animation_player.play()
			#animated_sprite_2d.visible = true
		
func explode():
	var splode := EXPLOSION.instantiate()
	add_sibling(splode)
	splode.position = get_child(0).global_position
	await splode.animation_finished
	score()
	queue_free()
		
func score():
	var egg := GRAVITY_EGG.instantiate()
	egg.global_position = get_child(0).global_position
	add_sibling(egg)
