extends Area2D

signal playerFire(poo_pellets, playerPosition, fireAngle)
signal playerSendCurrentHoldAmount(currentHoldAmount)
signal update_global_poo_label(dump_amount)

# Declare member variables here. Examples:
export (PackedScene) var poo_pellets
export var speed = 300
export var holdCapacity = 10
export var goblinStealAmount = 5
var currentHoldAmount = 0
var totalPooAmount = 0
var screen_size

onready var end_of_gun = $EndOfGun
onready var audio_ctrl = $MobAudioController

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = Vector2(3072, 3072)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.x > 0:
		$PlayerSprite.animation = "right"
	elif velocity.x < 0:
		$PlayerSprite.animation = "left"
	elif velocity.y > 0:
		$PlayerSprite.animation = "down"
	elif velocity.y < 0:
		$PlayerSprite.animation = "up"

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerSprite.play()
	else:
		$PlayerSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _unhandled_input(event):
	if event.is_action_pressed("player_fire"):
		var clickLocation = get_global_mouse_position()
		var fireAngle = rad2deg(clickLocation.angle_to_point(position))
		print("fire from ", position, " at an angle of ", fireAngle)
		shoot()

func _on_Player_area_entered(body):
	if (body.is_in_group("poo") && currentHoldAmount < holdCapacity):
		var poo = body as Poo
		var pooToAdd = clamp(poo.pooValue, 0, holdCapacity - currentHoldAmount)
		currentHoldAmount += pooToAdd		
		audio_ctrl.act(0) # the Poo pick up sound
		if(pooToAdd != poo.pooValue):
			poo.pooValue -= pooToAdd
		else:
			var goblins = get_tree().get_nodes_in_group("goblin")
			for node in goblins:
				var goblin = node as Goblin
				goblin.removePooFromTargets(body, false)
			poo.destroy()
	
	if(body.is_in_group("silo")):
		if currentHoldAmount > 0:
			audio_ctrl.act(1) # the Poo drop sound
			
		totalPooAmount += currentHoldAmount
		currentHoldAmount = 0
		
	emit_signal("playerSendCurrentHoldAmount", currentHoldAmount)
	emit_signal("update_global_poo_label", totalPooAmount)

func _on_Player_body_entered(body):
	if (body.is_in_group("goblin")):
		steal_poo(body.stealAmount)
		body.start_StealTimer()

func steal_poo(stealAmount: int):
	currentHoldAmount = clamp(currentHoldAmount - stealAmount, 0, currentHoldAmount)	
	emit_signal("playerSendCurrentHoldAmount", currentHoldAmount)

func shoot():
	var poo_pellets_instance = poo_pellets.instance()
	var target = get_global_mouse_position()
	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	emit_signal("playerFire", poo_pellets_instance, end_of_gun.global_position, direction_to_mouse)


func _on_Goblin_global_poo_stolen(stealAmount):
	totalPooAmount = max(0, totalPooAmount - stealAmount)
	emit_signal("update_global_poo_label", totalPooAmount)
