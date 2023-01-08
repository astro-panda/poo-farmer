extends KinematicBody2D
class_name Goblin

signal global_poo_stolen(stealAmount)

# Declare member variables here. Examples:
export var speed = 1500
onready var silo = get_tree().get_nodes_in_group("silo")[0]
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var audio_ctrl = $MobAudioController
var playerNearby = false
var playerHasPoo = false
var currentPooTargets = []
var health = 5
var stealAmount = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if playerNearby && playerHasPoo:
		velocity = move_at_body(player, delta)
	elif currentPooTargets.size() > 0:
		var currentPoo = currentPooTargets.front()
		while !is_instance_valid(currentPoo) && currentPooTargets.size() > 0:
			currentPooTargets.pop_front()
			if(currentPooTargets.size() > 0):
				currentPoo = currentPooTargets.front()
			
		if (is_instance_valid(currentPoo)):
			velocity = move_at_body(currentPoo, delta)
		else:
			velocity = move_at_body(silo, delta)
	else:
		velocity = (silo.position - position).normalized() * speed * delta
		velocity = move_and_slide(velocity)
		
	if velocity.x > 0:
		$AnimatedSprite.animation = "right"
	elif velocity.x < 0:
		$AnimatedSprite.animation = "left"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"


func _on_Visibility_area_entered(area):
	if (area.is_in_group("poo")):
		if(is_instance_valid(area) && !currentPooTargets.has(area)):
			currentPooTargets.push_back(area)
	if (area.is_in_group("player")):
		playerHasPoo = player.currentHoldAmount > 0
		playerNearby = true

func _on_Visibility_area_exited(area):
	playerNearby = false
	$StealTimer.stop()
	
func _on_PooPickupDetection_area_entered(area):
	if (area.is_in_group("poo")):
		removePooFromTargets(area, true)
	
	if (area.is_in_group("silo")):
		emit_signal("global_poo_stolen", stealAmount)


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
	var velocity = (body.position - position).normalized() * speed * delta
	return move_and_slide(velocity)	

func handle_hit():
	health -= 1
	print("Enemy hit!", health)
	if health <= 0:
		print("Gobo ded!")
		queue_free()
