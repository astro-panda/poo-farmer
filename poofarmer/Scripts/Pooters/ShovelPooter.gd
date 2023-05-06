extends Pooter
class_name ShovelPooter

func _on_FireCooldown_timeout():
	canFire = true
