extends Node


export(PackedScene) var enemy_scene
export var maxEnemies = 20
export var maxSpawnTime = 20.0
export var minSpawnTime = 4.0
var rnd = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	var rndSide = rnd.randi_range(0, 3)
	var rndLoc = rnd.randi_range(72, 3000)
	var enemy = enemy_scene.instance()
	var spawnLoc = Vector2(72, 72)
	if rndSide == 0:
		spawnLoc = Vector2(3000, rndLoc)
	elif rndSide == 1:
		spawnLoc = Vector2(rndLoc, 72)
	elif rndSide == 2:
		spawnLoc = Vector2(72, rndLoc)
	else:
		spawnLoc = Vector2(rndLoc, 3000)
	
	enemy.position = spawnLoc
	add_child(enemy)
	
	$SpawnTimer.wait_time = rand_range(minSpawnTime, maxSpawnTime)
