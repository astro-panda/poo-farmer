extends Node2D


@export (PackedScene) var poo_pellets


func _on_Player_firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode):
	if fireMode == FireMode.values.Shatgun:
		var leftPellet = poo_pellets.instantiate()
		leftPellet.damage = pelletInstance.damage
		leftPellet.poo_speed = pelletInstance.poo_speed
		leftPellet.distance = pelletInstance.distance
		var rightPellet = poo_pellets.instantiate()
		rightPellet.damage = pelletInstance.damage
		rightPellet.poo_speed = pelletInstance.poo_speed
		rightPellet.distance = pelletInstance.distance
		
		pelletInstance.global_position = spawnPosition
		pelletInstance.startLocation = spawnPosition
		leftPellet.global_position = spawnPosition
		leftPellet.startLocation = spawnPosition
		rightPellet.global_position = spawnPosition
		rightPellet.startLocation = spawnPosition
		
		pelletInstance.set_direction(angleToMouse)
		leftPellet.set_direction(angleToMouse.rotated(PI / 12))
		rightPellet.set_direction(angleToMouse.rotated(- PI / 12))
		add_child(pelletInstance)
		add_child(leftPellet)
		add_child(rightPellet)
	elif fireMode == FireMode.values.RocketLauncher:
		pelletInstance.global_position = spawnPosition
		pelletInstance.startLocation = spawnPosition
		pelletInstance.set_direction(angleToMouse)
		pelletInstance.willExplode = true
		add_child(pelletInstance)
	elif fireMode == FireMode.values.Railgun:
		pelletInstance.global_position = spawnPosition
		pelletInstance.startLocation = spawnPosition
		pelletInstance.set_direction(angleToMouse)
		pelletInstance.isRailShot = true
		pelletInstance.rotateAngle = spawnPosition.angle_to_point(mouseClick)
		add_child(pelletInstance)
	else:
		pelletInstance.global_position = spawnPosition
		pelletInstance.startLocation = spawnPosition
		pelletInstance.set_direction(angleToMouse)
		add_child(pelletInstance)
