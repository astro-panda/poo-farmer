extends Enemy
class_name Goblin


export var pooCapacity = 5
onready var sprite = $AnimatedSprite
var playerNearby = false
var playerHasPoo = false
var currentPooTargets = []
var poosPickedUp = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_dying:
		var velocity = Vector2()
		if position.distance_to(silo.position) <= 300:
			currentPooTargets.clear()
		if playerNearby && playerHasPoo && !isFleeing:
			velocity = move_at_body(player, delta)
		elif currentPooTargets.size() > 0 && poosPickedUp <= pooCapacity:
			var currentPoo = currentPooTargets.front()
			while !is_instance_valid(currentPoo) && currentPooTargets.size() > 0:
				currentPooTargets.pop_front()
				if(currentPooTargets.size() > 0):
					currentPoo = currentPooTargets.front()
				
			if (is_instance_valid(currentPoo)):
				velocity = move_at_body(currentPoo, delta)
			else:
				if isFleeing:
					velocity = (fleeingVector - position).normalized() * speed * delta * fleeSpeedMultiplier
					velocity = move_and_slide(velocity)
					if (position.distance_to(fleeingVector) < 50):
						isFleeing = false
				else:
					velocity = move_at_body(silo, delta)
		else:
			if isFleeing:
				velocity = (fleeingVector - position).normalized() * speed * delta * fleeSpeedMultiplier
				velocity = move_and_slide(velocity)
				if (position.distance_to(fleeingVector) < 50):
					isFleeing = false
					poosPickedUp = 0
			else:
				velocity = (silo.position - position).normalized() * speed * delta
				velocity = move_and_slide(velocity)
			
		calculate_sprite_direction(sprite, velocity)


func _on_Visibility_area_entered(area):
	if !is_dying:
		if (area.is_in_group("poo")):
			if(is_instance_valid(area) && !currentPooTargets.has(area)):
				currentPooTargets.push_back(area)
		if (area.is_in_group("player")):
			playerHasPoo = player.currentHoldAmount > 0
			playerNearby = true

func _on_Visibility_area_exited(area):
	if area.is_in_group("player"):
		playerNearby = false
		$StealTimer.stop()
	
func _on_PooPickupDetection_area_entered(area):
	detected_something(area, true)
	if !is_dying:
		if (area.is_in_group("poo")):
			poosPickedUp += 1
		
		if (area.is_in_group("silo")):
			poosPickedUp = 0


func removePooFromTargets(poo, destroy):
	if (poo.is_in_group("poo")):
		currentPooTargets.erase(poo)
		destroy_poo(poo)

func start_StealTimer():
	$StealTimer.start()

func _on_StealTimer_timeout():
	player.steal_poo(stealAmount)
	audio_ctrl.act(0)
	if(player.currentHoldAmount == 0):
		playerNearby = false

func handle_hit(damage):
	enemy_handle_hit(sprite, damage, 13)


func _on_AnimatedSprite_animation_finished():
	end_death(sprite)
