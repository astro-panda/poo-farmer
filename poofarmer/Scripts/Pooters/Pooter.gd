extends Node2D
class_name Pooter

signal firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)

export(PackedScene) var poo_pellets
export(FireMode.values) var currentFireMode = FireMode.values.Shovel
export(Array, AudioStream) var poot_sounds
export var enabled: bool = true
export var cooldown: float = 0.25
export var damage: int = 2
export var pooSpeed: int = 7
export var pooDistance: int = 300 
export var cost: float = 1

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var poot_player = $PootSound
onready var poo_pellets_manager = get_tree().get_nodes_in_group("poo_pellets_manager")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	cost *= player.holdCapacity
	$FireCooldown.wait_time = cooldown
	connect("firePoo", poo_pellets_manager, "_on_Player_firePoo")

func shoot(target: Vector2, currentAmmo: float, inifite_ammo: bool):
	if enabled && (currentAmmo >= cost || inifite_ammo):
		if !inifite_ammo:
			currentAmmo -= cost
		
		var poo_pellets_instance = poo_pellets.instance()
		poo_pellets_instance.damage = damage
		poo_pellets_instance.poo_speed = pooSpeed
		poo_pellets_instance.distance = pooDistance
		
		var direction_to_mouse = global_position.direction_to(target).normalized()
		emit_signal("firePoo", poo_pellets_instance, global_position, direction_to_mouse, target, currentFireMode)
		enabled = false
		$FireCooldown.start()
		poot()


func _on_FireCooldown_timeout():
	enabled = true
	
func poot():
	poot_player.stream = poot_sounds[randi() % poot_sounds.size()]
	poot_player.play()
