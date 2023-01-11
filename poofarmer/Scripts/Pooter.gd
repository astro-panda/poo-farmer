extends Node2D

signal firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)

export (PackedScene) var poo_pellets
export (FireMode.values) var currentFireMode = FireMode.values.Shovel
export(Array, AudioStream) var poot_sounds
export var cooldown: float = 0.25
export var damage: int = 2
export var pooSpeed: int = 7
export var pooDistance: int = 300 
export var cost: float = 1
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var poot_player = $Poot
var canFire = true



const cooldownDict = {
	FireMode.values.Shovel: 0.25,
	FireMode.values.Pistol: 0.2,
	FireMode.values.Shatgun: 0.5,
	FireMode.values.RocketLauncher: 1.5,
	FireMode.values.Scatling: 0.05,
	FireMode.values.Railgun: 1.0
}

var pooCostDict = {
	FireMode.values.Shovel: 0.1,
	FireMode.values.Pistol: 0.1,
	FireMode.values.Shatgun: 0.1,
	FireMode.values.RocketLauncher: 0.16,
	FireMode.values.Scatling: 0.01,
	FireMode.values.Railgun: 0.05
}
const dmgDict = {
	FireMode.values.Shovel: 2,
	FireMode.values.Pistol: 4,
	FireMode.values.Shatgun: 4,
	FireMode.values.RocketLauncher: 8,
	FireMode.values.Scatling: 1,
	FireMode.values.Railgun: 100
}

const pooSpeedDict = {
	FireMode.values.Shovel: 7,
	FireMode.values.Pistol: 10,
	FireMode.values.Shatgun: 10,
	FireMode.values.RocketLauncher: 5,
	FireMode.values.Scatling: 13,
	FireMode.values.Railgun: 1000
}

const pooDistDict = {
	FireMode.values.Shovel: 100,
	FireMode.values.Pistol: 200,
	FireMode.values.Shatgun: 150,
	FireMode.values.RocketLauncher: 150,
	FireMode.values.Scatling: 400,
	FireMode.values.Railgun: 4000
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for type in pooCostDict.keys():
		pooCostDict[type] *= player.holdCapacity
	cooldown = cooldownDict[currentFireMode]
	cost = pooCostDict[currentFireMode]
	damage = dmgDict[currentFireMode]
	pooSpeed = pooSpeedDict[currentFireMode]
	pooDistance = pooDistDict[currentFireMode]
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
		poot()


func _on_FireCooldown_timeout():
	canFire = true
	
func poot():
	var da_poot
	if currentFireMode != FireMode.values.RocketLauncher:
		da_poot = poot_sounds[randi() % poot_sounds.size()]
	else:
		da_poot = poot_sounds[0]
		
	poot_player.stream = da_poot
	poot_player.play()
