extends Camera2D

@export var speed = 25

func _process(delta):
	position.x += speed * delta
	print(position.x)
	$EnemyPath.position.x = position.x + 320
	print($EnemyPath.position.x)
	$EnemyPath/EnemySpawnLocation.position.x = $EnemyPath.position.x
	print($EnemyPath/EnemySpawnLocation.position.x)
