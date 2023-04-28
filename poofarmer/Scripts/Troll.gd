extends Enemy


@onready var troll_sprite = $AnimatedSprite2D

func _ready():
	sprite = troll_sprite
	sprite_scale = troll_sprite.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_dying:
		var _velocity = Vector2()
		if isFleeing:
			_velocity = (fleeingVector - position).normalized() * speed * delta * fleeSpeedMultiplier
			set_velocity(_velocity)
			move_and_slide()
			_velocity = _velocity
			if (position.distance_to(fleeingVector) < 50):
				isFleeing = false
		else:
			_velocity = (silo.position - position).normalized() * speed * delta
			set_velocity(_velocity)
			move_and_slide()
			_velocity = _velocity
			
		calculate_sprite_direction(_velocity)
	
func _on_PooPickupDetection_area_entered(area):
	detected_something(area, false)


func handle_hit(damage, poo):
	enemy_handle_hit(damage, 0, poo)


func _on_AnimatedSprite_animation_finished():
	end_death()
