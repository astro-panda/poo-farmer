extends Area2D

export(Texture) var turret_head_texture 
export(int) var ammo
export(FireMode.values) var type

var current_target: Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	$Head/TurretHead.texture = turret_head_texture	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !current_target:
		acquire_target()
	else:
		fire()

func fire():
	$Head/Pooter.poot()

func acquire_target():
	if !current_target:
		var enemies = []
		var overlaps = get_overlapping_bodies()

		for overlap in overlaps:
			if overlap.is_in_group("enemy"):
				enemies.push_back(overlap)

		if enemies.size() > 0:
			# Assuming the first is the closest only to validate in a moment
			var closest_enemy = enemies[0];
			var assumed_closest_distance = 0;
			var current_enemy_distance = 0;

			for enemy in enemies:
				assumed_closest_distance = closest_enemy.global_position.distance_to(global_position)
				current_enemy_distance = enemy.global_position.distance_to(global_position)

				if current_enemy_distance < assumed_closest_distance:
					closest_enemy = enemy

			global_rotation = global_position.angle_to_point(closest_enemy.global_position) + 1.5708
			
			current_target = closest_enemy
