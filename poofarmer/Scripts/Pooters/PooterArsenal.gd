extends Node2D
class_name PooterArsenal

export var infinite_ammo: bool = false

onready var shovel = $ShovelPooter
onready var pistol = $PistolPooter
onready var shatgun = $ShatgunPooter
onready var rocket = $RocketPooter
onready var scatling = $ScatlingPooter
onready var railgun = $RailgunPooter

var pooters

var current_pooter: Pooter

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
	
	for mode in pooters.keys():
		var the_pooter = pooters[mode]
		the_pooter.connect("on_ammo_used", self, "on_shot_spent")
		the_pooter.fire_mode = mode
	
	current_pooter = pooters[FireMode.values.Shovel]
	
func _physics_process(delta):
	if current_pooter:
		current_pooter.current_ammo = GlobalState.player_current_hold_amount

func select_weapon(type):
	var the_pooter = pooters[type]
	
	if the_pooter && the_pooter.enabled:
		current_pooter = pooters[type]
		
func enable_weapon(type):
	var the_pooter = pooters[type]
	
	if the_pooter:
		the_pooter.enabled = true

func disable_weapon(type):
	var the_pooter = pooters[type]
	
	if the_pooter:
		the_pooter.enabled = false
		
func is_weapon_enabled(type) -> bool:
	var the_pooter = pooters[type]
	
	if the_pooter:
		return the_pooter.enabled
		
	return false
		
func on_shot_spent(shot_cost: float) -> void:
	GlobalState.player_current_hold_amount -= shot_cost

func shoot():
	current_pooter.shoot(get_global_mouse_position(), infinite_ammo)
