extends Area2D

@export var score := 50

func _ready():
	$AnimationPlayer.play("chill")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#score *= difficulty
	if $DespawnTimer.time_left < 3:
		$AnimationPlayer.play("blink")
	if $AnimationPlayer.current_animation == "blink" and $DespawnTimer.is_stopped():
		queue_free()
