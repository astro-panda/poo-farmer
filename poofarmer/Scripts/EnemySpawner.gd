extends Node

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var goblins = $Goblins
onready var trolls = $Trolls
var list_of_enemy_nodes = []
onready var Timers = {
	"spawn": $SpawnTimer, 
	"generation": $GenerationTimer, 
	"hud": $HudUpdateTimer
}

export (PackedScene) var goblin_enemy_scene
export (PackedScene) var troll_enemy_scene
export var maxEnemies = 20
export var maxSpawnTime = 40.0
export var minSpawnTime = 15.0
var rnd = RandomNumberGenerator.new()
var goblin_population = 20
var wave_count = 1
var current_population
var population_countdown
var doneSpawning = false
var num_enemies_spawned = 0
var num_trolls_spawned = 0
var num_enemies_killed = 0
var troll_spawn_numbers = []
var spawning_troll = false
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	list_of_enemy_nodes = [goblins, trolls]
	current_population = 3
	population_countdown = current_population
	Timers.spawn.start()
	Timers.hud.start()
	Timers.generation.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	if (get_enemy_count() < maxEnemies) && started:
		var rndSide = rnd.randi_range(0, 3)
		var rndLoc = rnd.randi_range(72, 3000)
		
		var enemy = goblin_enemy_scene.instance()
		if troll_spawn_numbers.has(num_enemies_spawned - 1):
			enemy = troll_enemy_scene.instance()
			num_trolls_spawned += 1
			spawning_troll = true
		
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
		enemy.connect("enemy_killed", goblins, "_on_enemy_killed")
		
		if population_countdown > 0:
			population_countdown -= 1
			if spawning_troll:
				trolls.add_child(enemy)
			else:
				goblins.add_child(enemy)
			num_enemies_spawned += 1
		else:
			doneSpawning = true
			if get_enemy_count() == 0 && Timers.generation.is_stopped():
				Timers.generation.wait_time = rand_range(minSpawnTime, maxSpawnTime)
				Timers.generation.start()
		


func _on_GenerationTimer_timeout():
	if started:
		if wave_count == 1: 
			current_population = 14
		current_population = int(floor(current_population * rnd.randf_range(1.5, 1.8)))
		population_countdown = current_population
		wave_count += 1
		if wave_count % 3 == 0:
			Timers.spawn.wait_time *= 0.5
		doneSpawning = false
		num_enemies_spawned = 0
		num_trolls_spawned = 0
		troll_spawn_numbers.clear()
		if current_population > 20:
			for i in range(int(floor(current_population / 20))):
				troll_spawn_numbers.append(rnd.randi_range(1, 20) + (i * 20))
		Timers.spawn.start()
	
func _on_HudUpdateTimer_timeout():
	var waveCountdown = !Timers.generation.is_stopped()
	var waveInfo = wave_count
	if waveCountdown:
		waveInfo = floor(Timers.generation.time_left)
	goblins.update_goblin_hud(current_population, waveInfo, Timers.generation.wait_time, waveCountdown)


func get_enemy_count():
	var num_enemies = 0
	for enemy_node in list_of_enemy_nodes:
		num_enemies += enemy_node.get_child_count()
	return num_enemies
	
func get_enemy_list():
	var enemies = []
	for enemy_node in list_of_enemy_nodes:
		enemies.append_array(enemy_node.get_children())
	return enemies
