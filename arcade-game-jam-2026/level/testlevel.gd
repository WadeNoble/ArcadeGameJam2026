extends Node2D

@export var seeker_scene: PackedScene

@onready var enemy_spawn_location: PathFollow2D = $Camera/EnemyPath/EnemySpawnLocation

	
func respawn():
	$Player.start($SpawnPosition.position)
	$Player/DeathTimer.start()
	#dummy function for now


func _on_player_game_over() -> void:
	pass # Replace with function body.

func _on_seeker_timer_timeout() -> void:
	#instantiate a randomly spawning, horizontally flying enemy
	var seeker = seeker_scene.instantiate()
	#set spawn location as a spot on EnemyPath
	var seeker_spawn_location = enemy_spawn_location
	#somewhere on the right side of the screen
	seeker_spawn_location.progress_ratio = randf()
	
	#set actual position to that of spawn location
	seeker.position = seeker_spawn_location.position
	print(seeker.position)
	#shoot parallel to path
	var s_direction = seeker_spawn_location.rotation + PI/2
	#add to scene tree
	add_child(seeker)
	
	
#start moving camera/boundaries faster?, increment "difficulty"?
func _on_difficulty_timer_timeout() -> void:
	modulate = "ffffaa"
