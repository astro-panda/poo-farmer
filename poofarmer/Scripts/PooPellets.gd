extends Area2D

export(float) var poo_speed = 10.0

var damage
var fire_rate
var attack_area
var attack_range
var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * poo_speed

		global_position += velocity

func set_direction(new_direction: Vector2):
	direction = new_direction

func _on_PooPellets_body_entered(body):
	print ("Poojectile hits")
	if body.has_method("handle_hit"):
		body.handle_hit()
		queue_free()
