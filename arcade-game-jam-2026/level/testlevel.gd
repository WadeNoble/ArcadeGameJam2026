extends Node2D

@onready var enemy_spawn_location: PathFollow2D = $Camera/EnemyPath/EnemySpawnLocation
@export var total_score := 0
@export var difficulty :=0
var time_played := 0

func _process(_delta: float) -> void:
	total_score = $Player.score

func respawn():
	#dummy function for now
	$Player.start($SpawnPosition.position)
	$Player/DeathTimer.start()
	

func _on_player_game_over() -> void:
	$"/root/Fader".fade_out()
	for child in get_children():
		child.process_mode = PROCESS_MODE_DISABLED
	await $"/root/Fader/FaderTimer".timeout
	Fader.fade_in()
	var end_scene = load("res://main_menu.tscn").instantiate()
	get_parent().get_parent().add_sibling(end_scene)
	queue_free()
	
#start moving camera/boundaries faster?, increment "difficulty"?
func _on_difficulty_timer_timeout() -> void:
	difficulty += 1
	if difficulty > 5:
		modulate = "ffffaa"
