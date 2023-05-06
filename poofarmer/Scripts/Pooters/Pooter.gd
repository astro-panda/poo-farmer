extends Node2D
class_name Pooter

signal firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)

export(PackedScene) var poo_pellets
export(FireMode.values) var currentFireMode = FireMode.values.Shovel
export(Array, AudioStream) var poot_sounds
export var cooldown: float = 0.25
export var damage: int = 2
export var pooSpeed: int = 7
export var pooDistance: int = 300 
export var cost: float = 1

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var poot_player = $Poot

var canFire = true

# Called when the node enters the scene tree for the first time.
func _ready():	
	cost *= player.holdCapacity
	$FireCooldown.wait_time = cooldown

func shoot():
	if canFire && (player.currentHoldAmount >= cost || player.disable_ammo):
		if !player.disable_ammo:
			player.currentHoldAmount -= cost
		
		var poo_pellets_instance = poo_pellets.instance()
		poo_pellets_instance.damage = damage
		poo_pellets_instance.poo_speed = pooSpeed
		poo_pellets_instance.distance = pooDistance
		
		var target = get_global_mouse_position()
		var direction_to_mouse = global_position.direction_to(target).normalized()
		emit_signal("firePoo", poo_pellets_instance, global_position, direction_to_mouse, target, currentFireMode)
		canFire = false
		$FireCooldown.start()
		poot()


func _on_FireCooldown_timeout():
	canFire = true
	
func poot():
	poot_player.stream = poot_sounds[randi() % poot_sounds.size()]
	poot_player.play()
