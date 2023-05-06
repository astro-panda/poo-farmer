extends Area2D

export(Texture) var turret_head_texture 
export(PackedScene) var turret_pooter
export(int) var ammo

# Declare member variables here. Examples:
var pooter: Pooter

var current_target: Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	$Head/TurretHead.texture = turret_head_texture
	pooter = turret_pooter.instance()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# aim at the closest enemy
	pass
	
	
