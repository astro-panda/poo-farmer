extends Node2D
class_name Pooter

signal firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)
signal on_ammo_used(used_amount)

export(PackedScene) var poo_pellets
export(FireMode.values) var currentFireMode = FireMode.values.Shovel
export(Array, AudioStream) var poot_sounds
export var enabled: bool = true
export var cooldown: float = 0.25
export var damage: int = 2
export var pooSpeed: int = 7
export var pooDistance: int = 300
export var cost: float = 1
export var ammo_max: float = 10

onready var poot_player = $PootSound
onready var cooldown_timer = $FireCooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	cost *= ammo_max
	cooldown_timer.wait_time = cooldown
	connect("firePoo", PooPelletsManager, "_on_firePoo")
	cooldown_timer.connect("timeout", self, "_on_FireCooldown_timeout")

func shoot(target: Vector2, currentAmmo: float, inifite_ammo: bool):
	if enabled && (currentAmmo >= cost || inifite_ammo):
		if !inifite_ammo:
			currentAmmo -= cost
			emit_signal("on_ammo_used", cost)
		
		var poo_pellets_instance = poo_pellets.instance()
		poo_pellets_instance.damage = damage
		poo_pellets_instance.poo_speed = pooSpeed
		poo_pellets_instance.distance = pooDistance
		
		var direction_to_mouse = global_position.direction_to(target).normalized()
		print("fire pellet")
		emit_signal("firePoo", poo_pellets_instance, global_position, direction_to_mouse, target, currentFireMode)
		enabled = false
		$FireCooldown.start()
		poot()

func _on_FireCooldown_timeout():
	print("fire cooldown")
	enabled = true
	
func poot():
	poot_player.stream = poot_sounds[randi() % poot_sounds.size()]
	poot_player.play()
