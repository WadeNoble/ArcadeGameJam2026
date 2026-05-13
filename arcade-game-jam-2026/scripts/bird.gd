extends Node2D

const EXPLOSION = preload("res://explosion.tscn")

@onready var animation_player: AnimationPlayer = $Bird/AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $Bird/AnimatedSprite2D
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $Bird/VisibleOnScreenEnabler2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("flap")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	animation_player.play("fly")
	#can try adding non-straight flight patterns - sin() is an option
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_projectiles"):
		body.queue_free()
		explode()
		
		
func explode():
	var splode := EXPLOSION.instantiate()
	splode.global_position = global_position
	add_sibling(splode)
	queue_free()
		
