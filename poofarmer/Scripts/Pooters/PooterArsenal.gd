extends Node2D
class_name PooterArsenal

export var ammo: int = 0
export var infinite_ammo: bool = false

onready var shovel = $ShovelPooter
onready var pistol = $PistolPooter
onready var shatgun = $ShatgunPooter
onready var rocket = $RocketPooter
onready var scatling = $ScatlingPooter
onready var railgun = $RailgunPooter

var pooters

var currentWeapon: Pooter

# Called when the node enters the scene tree for the first time.
func _ready():
	pooters = {
		FireMode.values.Shovel: shovel,
		FireMode.values.Pistol: pistol,
		FireMode.values.Shatgun: shatgun,
		FireMode.values.RocketLauncher: rocket,
		FireMode.values.Scatling: scatling,
		FireMode.values.Railgun: railgun
	}
	
	currentWeapon = pooters[FireMode.values.Shovel]


func select_weapon(type: FireMode):
	currentWeapon = pooters[type]
	
func fire():
	currentWeapon.shoot(ammo, infinite_ammo)
