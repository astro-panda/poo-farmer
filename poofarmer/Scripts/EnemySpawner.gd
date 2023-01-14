extends Node

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var goblins = $Goblins
onready var Timers = {
	"spawn": $SpawnTimer, 
	"generation": $GenerationTimer, 
	"hud": $HudUpdateTimer
}

export(PackedScene) var enemy_scene
export var maxEnemies = 20
export var maxSpawnTime = 40.0
export var minSpawnTime = 15.0
var rnd = RandomNumberGenerator.new()
var goblin_population = 20
var wave_count = 1
var current_population
var population_countdown

# Called when the node enters the scene tree for the first time.
func _ready():
	current_population = 3
	population_countdown = current_population
	Timers.spawn.start()
	Timers.hud.start()
	Timers.generation.stop()


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
		enemy.fleeingVector = spawnLoc
		enemy.speed *= 1 + (wave_count - 1) / 10
		enemy.connect("global_poo_stolen", player, "_on_Goblin_global_poo_stolen")
		
		if population_countdown > 0:
			population_countdown -= 1
			goblins.add_child(enemy)
		else:
			if goblins.get_child_count() == 0 && Timers.generation.is_stopped():
				Timers.generation.wait_time = rand_range(minSpawnTime, maxSpawnTime)
				Timers.generation.start()
		


func _on_GenerationTimer_timeout():
	if wave_count == 1: 
		current_population = 14
	current_population = floor(current_population * rnd.randf_range(1.5, 1.8))
	population_countdown = current_population
	wave_count += 1
	if wave_count % 3 == 0:
		Timers.spawn.wait_time *= 0.5
	Timers.spawn.start()
	
func _on_HudUpdateTimer_timeout():
	var waveCountdown = !Timers.generation.is_stopped()
	var waveInfo = wave_count
	if waveCountdown:
		waveInfo = floor(Timers.generation.time_left)
	goblins.update_goblin_hud(current_population, waveInfo, Timers.generation.wait_time, waveCountdown)
