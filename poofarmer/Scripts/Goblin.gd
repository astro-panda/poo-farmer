extends Enemy
class_name Goblin


@export var pooCapacity = 5
@onready var goblin_sprite = $AnimatedSprite2D
var playerNearby = false
var playerHasPoo = false
var currentPooTargets = []
var poosPickedUp = 0

func _ready():
	sprite = goblin_sprite
	sprite_scale = goblin_sprite.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_dying:
		var _velocity = Vector2()
		if position.distance_to(silo.position) <= 300:
			currentPooTargets.clear()
		if playerNearby && playerHasPoo && !isFleeing:
			_velocity = move_at_body(player, delta)
		elif currentPooTargets.size() > 0 && poosPickedUp <= pooCapacity:
			var currentPoo = currentPooTargets.front()
			while !is_instance_valid(currentPoo) && currentPooTargets.size() > 0:
				currentPooTargets.pop_front()
				if(currentPooTargets.size() > 0):
					currentPoo = currentPooTargets.front()
				
			if (is_instance_valid(currentPoo)):
				_velocity = move_at_body(currentPoo, delta)
			else:
				if isFleeing:
					_velocity = (fleeingVector - position).normalized() * speed * delta * fleeSpeedMultiplier
					set_velocity(_velocity)
					move_and_slide()
					_velocity = _velocity
					if (position.distance_to(fleeingVector) < 50):
						isFleeing = false
				else:
					_velocity = move_at_body(silo, delta)
		else:
			if isFleeing:
				_velocity = (fleeingVector - position).normalized() * speed * delta * fleeSpeedMultiplier
				set_velocity(_velocity)
				move_and_slide()
				_velocity = _velocity
				if (position.distance_to(fleeingVector) < 50):
					isFleeing = false
					poosPickedUp = 0
			else:
				_velocity = (silo.position - position).normalized() * speed * delta
				set_velocity(_velocity)
				move_and_slide()
				_velocity = _velocity
			
		calculate_sprite_direction(_velocity)


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


func removePooFromTargets(poo):
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

func handle_hit(damage, poo):
	enemy_handle_hit(damage, 13, poo)


func _on_AnimatedSprite_animation_finished():
	end_death()
