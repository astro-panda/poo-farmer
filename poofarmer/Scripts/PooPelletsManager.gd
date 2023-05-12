extends Node2D

onready var poo_pellets = preload("res://Scenes/PooPellets.tscn")

func _on_firePoo(pellet, spawn_position, angle_to_target, target_position):
	match pellet.fire_mode:
		FireMode.values.Shatgun:
			var leftPellet = poo_pellets.instance()
			leftPellet.damage = pellet.damage
			leftPellet.poo_speed = pellet.poo_speed
			leftPellet.distance = pellet.distance
			
			var rightPellet = poo_pellets.instance()
			rightPellet.damage = pellet.damage
			rightPellet.poo_speed = pellet.poo_speed
			rightPellet.distance = pellet.distance
			
			pellet.global_position = spawn_position
			pellet.startLocation = spawn_position
			leftPellet.global_position = spawn_position
			leftPellet.startLocation = spawn_position
			rightPellet.global_position = spawn_position
			rightPellet.startLocation = spawn_position

			pellet.set_direction(angle_to_target)
			leftPellet.set_direction(angle_to_target.rotated(PI / 12))
			rightPellet.set_direction(angle_to_target.rotated(- PI / 12))
			add_child(pellet)
			add_child(leftPellet)
			add_child(rightPellet)

		FireMode.values.RocketLauncher:
			pellet.global_position = spawn_position
			pellet.startLocation = spawn_position
			pellet.set_direction(angle_to_target)
			pellet.willExplode = true
			add_child(pellet)

		FireMode.values.Railgun:
			pellet.global_position = spawn_position
			pellet.startLocation = spawn_position
			pellet.set_direction(angle_to_target)
			pellet.isRailShot = true
			pellet.rotateAngle = spawn_position.angle_to_point(target_position)
			add_child(pellet)

		_:
			pellet.global_position = spawn_position
			pellet.startLocation = spawn_position
			pellet.set_direction(angle_to_target)
			add_child(pellet)
