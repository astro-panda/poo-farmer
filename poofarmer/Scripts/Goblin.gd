extends KinematicBody2D
class_name Goblin

signal global_poo_stolen(stealAmount)
signal enemy_killed

# Declare member variables here. Examples:
export var speed = 4000
export var fleeSpeedMultiplier = 4
export var pooCapacity = 5
onready var silo = get_tree().get_nodes_in_group("silo")[0]
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var audio_ctrl = $MobAudioController
onready var sprite = $AnimatedSprite
var playerNearby = false
var playerHasPoo = false
var currentPooTargets = []
var health = 4
var stealAmount = 3
var siloStealAmount = 5
var poosPickedUp = 0
var isFleeing = false
var fleeingVector = Vector2(0,0)
var is_dying = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
			
		if velocity.x > 0:
			sprite.animation = "right"
		elif velocity.x < 0:
			sprite.animation = "left"
		elif velocity.y > 0:
			sprite.animation = "down"
		elif velocity.y < 0:
			sprite.animation = "up"


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
	if !is_dying:
		if (area.is_in_group("poo")):
			removePooFromTargets(area, true)
			poosPickedUp += 1
		
		if (area.is_in_group("silo")):
			emit_signal("global_poo_stolen", siloStealAmount)
			isFleeing = true
			poosPickedUp = 0
			
		if area.is_in_group("player") && playerHasPoo:
			isFleeing = true
			player.steal_poo(stealAmount)
			audio_ctrl.act(0)


func removePooFromTargets(poo, destroy):
	if (poo.is_in_group("poo")):
		var pooInstance = poo as Poo
		currentPooTargets.erase(poo)
		if (destroy):
			pooInstance.destroy()

func start_StealTimer():
	$StealTimer.start()

func _on_StealTimer_timeout():
	player.steal_poo(stealAmount)
	audio_ctrl.act(0)
	if(player.currentHoldAmount == 0):
		playerNearby = false
		
func move_at_body(body, delta):
	var velocity = (body.position - position).normalized() * speed * delta * (fleeSpeedMultiplier if isFleeing else 1)
	return move_and_slide(velocity)

func handle_hit(damage):
	health -= damage
	if health <= 0 && !is_dying:
		# the offset is becasue the death sprite is a different size than the regular one
		sprite.offset.y = 13
		if sprite.animation == "right":
			sprite.flip_h = true
		sprite.play("death")
		is_dying = true


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "death":
		queue_free()
		emit_signal("enemy_killed")
