extends KinematicBody2D

signal global_poo_stolen(stealAmount)

# Declare member variables here. Examples:
export var speed = 2000
export var fleeSpeedMultiplier = 1
onready var silo = get_tree().get_nodes_in_group("silo")[0]
onready var audio_ctrl = $MobAudioController
var health = 16
var stealAmount = 5
var siloStealAmount = 10
var isFleeing = false
var fleeingVector = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if isFleeing:
		velocity = (fleeingVector - position).normalized() * speed * delta * fleeSpeedMultiplier
		velocity = move_and_slide(velocity)
		if (position.distance_to(fleeingVector) < 50):
			isFleeing = false
	else:
		velocity = (silo.position - position).normalized() * speed * delta
		velocity = move_and_slide(velocity)
		
	if velocity.x > 4:
		$AnimatedSprite.animation = "right"
	elif velocity.x < -4:
		$AnimatedSprite.animation = "left"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"
	
func _on_PooPickupDetection_area_entered(area):
	if (area.is_in_group("poo")):
		removePooFromTargets(area, true)
	
	if (area.is_in_group("silo")):
		emit_signal("global_poo_stolen", siloStealAmount)
		isFleeing = true


func removePooFromTargets(poo, destroy):
	if (poo.is_in_group("poo")):
		var pooInstance = poo as Poo
		if (destroy):
			pooInstance.destroy()
		
func move_at_body(body, delta):
	var velocity = (body.position - position).normalized() * speed * delta * (fleeSpeedMultiplier if isFleeing else 1)
	return move_and_slide(velocity)

func handle_hit(damage):
	health -= damage
	if health <= 0:
		queue_free()
