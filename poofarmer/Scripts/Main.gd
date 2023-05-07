extends Node

onready var start_screen = $StartScreen
onready var poo_pellets_manager = $PooPelletsManager
onready var hud = $HUD
onready var player  = get_tree().get_nodes_in_group("player")[0]

var animal_spawner_scene = preload("res://Scenes/Animal/AnimalSpawner.tscn")
var enemy_spawner_scene = preload("res://Scenes/EnemySpawner.tscn")

# preload spawner scenes to enable global game reset
var animal_spawner
var enemy_spawner

var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()	
	reset()
	
func reset():
	get_tree().call_group("poo", "queue_free")
	#get_tree().call_group("goblin", "queue_free")
	
	if animal_spawner != null:
		animal_spawner.queue_free()
		animal_spawner = null
		
	if enemy_spawner != null: 
		enemy_spawner.queue_free()
		enemy_spawner = null
	
	if animal_spawner == null:
		animal_spawner = animal_spawner_scene.instance()
	
	if enemy_spawner == null:
		enemy_spawner = enemy_spawner_scene.instance()
	
	enemy_spawner.started = false
	animal_spawner.spawn_animals = false
	add_child(animal_spawner)
	add_child(enemy_spawner)
	player.goboSpawner = enemy_spawner

	var _player = player as Player
	if game_started:
		GlobalState.reset()
		player.reset()
		hud.reset()
		enemy_spawner.started = true
		animal_spawner.spawn_animals = true

	game_started = true

func quit():
	start_screen.begin()
	enemy_spawner.started = true
	animal_spawner.spawn_animals = true
	reset()


func _on_StartScreen_game_started():
	enemy_spawner.started = true
	animal_spawner.spawn_animals = true
