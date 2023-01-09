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

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#player.connect("playerFire", poo_pellets_manager, "handle_poo_pellets")
	reset()
	
func reset():
	get_tree().call_group("poo", "queue_free")
	get_tree().call_group("goblin", "queue_free")	
	
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
		
	add_child(animal_spawner)
	add_child(enemy_spawner)
	
	hud.update_global_poo_label(0)
	hud.update_global_goblin_label(0)	
	
	var _player = player as Player
	player.reset()

func quit():
	start_screen.begin()
	reset()
