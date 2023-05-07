extends "res://Scripts/Turret.gd"




	


func oscillate_sprite(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode):
	$Head/TurretHead.flip_h = !$Head/TurretHead.flip_h
