extends Pooter
class_name RailgunPooter

func _on_FireCooldown_timeout():
	canFire = true
