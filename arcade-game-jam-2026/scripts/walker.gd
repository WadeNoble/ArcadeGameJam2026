extends CharacterBody2D


var speed = 100
var direction = -1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

#var is_alive = true

func _ready():
	add_to_group("Enemy")

func _physics_process(delta: float) -> void:
	#should never leave the platform, but just in case
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
		#is_alive = false
		queue_free()
	
func turn():
	direction = -direction
	scale.x = scale.x * -1


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	show()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
