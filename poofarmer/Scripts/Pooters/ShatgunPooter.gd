extends Pooter
class_name ShatgunPooter

func _on_FireCooldown_timeout():
	canFire = true
