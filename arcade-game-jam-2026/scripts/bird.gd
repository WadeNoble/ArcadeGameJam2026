extends Node2D

const EXPLOSION = preload("res://explosion.tscn")
const GRAVITY_EGG = preload("res://gravity_egg.tscn")

@onready var animation_player: AnimationPlayer = $Bird/AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $Bird/AnimatedSprite2D
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $Bird/VisibleOnScreenEnabler2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("flap")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	animation_player.play("fly")
	#can try adding non-straight flight patterns - sin() is an option
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if position.x <= $"../Camera".position.x:
		queue_free()
	else:
		explode()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_projectiles"):
		body.queue_free()
		hide()
		
		
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
