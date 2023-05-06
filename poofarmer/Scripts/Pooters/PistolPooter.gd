extends Pooter
class_name PistolPooter

func _on_FireCooldown_timeout():
	canFire = true
