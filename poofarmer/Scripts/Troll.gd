extends Enemy


onready var troll_sprite = $AnimatedSprite

func _ready():
	sprite = troll_sprite
	sprite_scale = troll_sprite.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_dying:
		var velocity = Vector2()
		if isFleeing:
			velocity = (fleeingVector - position).normalized() * speed * delta * fleeSpeedMultiplier
			velocity = move_and_slide(velocity)
			if (position.distance_to(fleeingVector) < 50):
				isFleeing = false
		else:
			velocity = (silo.position - position).normalized() * speed * delta
			velocity = move_and_slide(velocity)
			
		calculate_sprite_direction(velocity)
	
func _on_PooPickupDetection_area_entered(area):
	detected_something(area, false)


func handle_hit(damage, poo):
	enemy_handle_hit(damage, 0, poo)


func _on_AnimatedSprite_animation_finished():
	end_death()
