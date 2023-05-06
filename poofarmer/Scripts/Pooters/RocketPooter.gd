extends Pooter
class_name RocketPooter

func _on_FireCooldown_timeout():
	canFire = true
