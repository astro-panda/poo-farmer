extends Node

onready var player = get_tree().get_nodes_in_group("player")[0]

export(PackedScene) var enemy_scene
export var maxEnemies = 20
export var maxSpawnTime = 30.0
export var minSpawnTime = 10.0
var rnd = RandomNumberGenerator.new()
var goblin_populations = [20,20,40,60,60]
var current_population

# Called when the node enters the scene tree for the first time.
func _ready():
	current_population = goblin_populations.pop_front()
	$SpawnTimer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	if get_child_count() < maxEnemies:
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
		enemy.connect("global_poo_stolen", player, "_on_Goblin_global_poo_stolen")
		
		current_population -= 1
		add_child(enemy)
		if current_population == 0:
			$SpawnTimer.stop()
			$GenerationTimer.start()
		
	$SpawnTimer.wait_time = rand_range(minSpawnTime, maxSpawnTime)


func _on_GenerationTimer_timeout():
	if goblin_populations.size() > 0:
		current_population = goblin_populations.pop_front()
		$SpawnTimer.start()
	else:
		$GenerationTimer.stop()
	
