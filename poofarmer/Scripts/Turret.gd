extends Area2D

export(Texture) var turret_head_texture 
export(int) var ammo
export(FireMode.values) var type
export(bool) var infinite_ammo = false

var current_target: Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	$Head/TurretHead.texture = turret_head_texture
	$Visibility/CollisionShape2D.shape.radius = $Head/Pooter.pooDistance
	$AmmoBar.max_value = ammo
	$AmmoBar.value = ammo
	$AmmoBar.step = ammo / 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	acquire_target()
	fire()

func fire():
	if current_target:
		$Head/Pooter.shoot(current_target.global_position, ammo, infinite_ammo)

func acquire_target():
	var closest_enemy
	var enemies = []
	var overlaps = $Visibility.get_overlapping_bodies()

	for overlap in overlaps:
		if overlap.is_in_group("enemy"):
			enemies.push_back(overlap)
			
	var target_in_range = enemies.find(current_target)	

	if target_in_range < 0:
		current_target = null

	if !current_target:
		if enemies.size() > 0:
			# Assuming the first is the closest only to validate in a moment
			closest_enemy = enemies[0];
			var assumed_closest_distance = 0;
			var current_enemy_distance = 0;

			for enemy in enemies:
				assumed_closest_distance = closest_enemy.global_position.distance_to(global_position)
				current_enemy_distance = enemy.global_position.distance_to(global_position)

				if current_enemy_distance < assumed_closest_distance:
					closest_enemy = enemy

			current_target = closest_enemy
	else:
		closest_enemy = current_target
	
	if closest_enemy:		
		$Head.global_rotation = $Head.global_position.angle_to_point(closest_enemy.global_position) - 1.5708
		

func update_ammo(used_amount: int):
	ammo -= used_amount
	$AmmoBar.value = ammo
