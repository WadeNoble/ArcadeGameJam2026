extends Camera2D

@export var speed = 25

func _process(delta):
	position.x += speed * delta
	$EnemyPath.position.x = position.x + 320
	$EnemyPath/EnemySpawnLocation.position.x = $EnemyPath.position.x
	print($EnemyPath.position.x, " ", position.x)
