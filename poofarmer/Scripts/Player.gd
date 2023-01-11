extends KinematicBody2D
class_name Player

signal firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)
signal playerSendCurrentHoldAmount(currentHoldAmount)
signal update_global_poo_label(dump_amount)
signal game_on()

# Declare member variables here. Examples:
export (PackedScene) var poo_pellets
export var speed = 250
export var holdCapacity = 10
export var goblinStealAmount = 5
export var currentHoldAmount = 0
export var totalPooAmount = 0
var screen_size
var gross_poo_harvested = 0
var shoot_enabled = false
var disable_ammo = false

var fireModes = [FireMode.values.Shovel]
export(FireMode.values) var equippedFireMode = FireMode.values.Shovel

onready var hud = get_tree().get_nodes_in_group("hud")[0]
onready var silo = get_tree().get_nodes_in_group("silo")[0]

onready var modal_window = $ModalWindow
onready var game_on_timer = $GameOnTimer
onready var audio_ctrl = $MobAudioController
onready var speech = $PlayerSprite/SpeechBubble
onready var arrow_handle = $PlayerSprite/SpeechBubble/ArrowHandle
onready var shovelPooter = $ShovelPooter
onready var pistolPooter = $PistolPooter
onready var shatgunPooter = $ShatgunPooter
onready var rocketLauncherPooter = $RocketLauncherPooter
onready var scatlingPooter = $ScatlingPooter
onready var railgunPooter = $RailgunPooter

onready var pooterDict = {
	FireMode.values.Shovel: shovelPooter,
	FireMode.values.Pistol: pistolPooter,
	FireMode.values.Shatgun: shatgunPooter,
	FireMode.values.RocketLauncher: rocketLauncherPooter,
	FireMode.values.Scatling: scatlingPooter,
	FireMode.values.Railgun: railgunPooter
}

onready var silo_subItem = $PlayerSprite/SpeechBubble/Silo

var subItems = [silo_subItem]

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = Vector2(3072, 3072)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	if Input.is_action_pressed("game_over"):
#		game_over()

func _physics_process(_delta):
	if shoot_enabled && Input.is_action_pressed("player_fire"):
		pooterDict[equippedFireMode].shoot()
		
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	# shhhhh our little secret
	if Input.is_action_pressed("modifier"):
		if Input.is_action_pressed("deep_pockets"):
			disable_ammo = !disable_ammo
		if Input.is_action_pressed("shovel"):
			equippedFireMode = FireMode.values.Shovel
		if Input.is_action_pressed("pistol"):
			equippedFireMode = FireMode.values.Pistol
		if Input.is_action_pressed("shatgun"):
			equippedFireMode = FireMode.values.Shatgun
		if Input.is_action_pressed("scatling"):
			equippedFireMode = FireMode.values.Scatling
		if Input.is_action_pressed("launcher"):
			equippedFireMode = FireMode.values.RocketLauncher
		if Input.is_action_pressed("railgun"):
			equippedFireMode = FireMode.values.Railgun
		
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
	
	# Move the player
	move_and_slide(velocity * _delta)


func _on_Area2D_area_entered(body):
	if (body.is_in_group("poo")):
		if (currentHoldAmount < holdCapacity):
			var poo = body as Poo
			var pooToAdd = clamp(poo.pooValue, 0, holdCapacity - currentHoldAmount)
			currentHoldAmount += pooToAdd		
			audio_ctrl.act(0) # the Poo pick up sound
			if(pooToAdd != poo.pooValue):
				poo.pooValue -= pooToAdd
				print("show silo")
				show_speech(silo_subItem, silo)
			else:
				var goblins = get_tree().get_nodes_in_group("goblin")
				for node in goblins:
					var goblin = node as Goblin
					goblin.removePooFromTargets(body, false)
				poo.destroy()
		else:
			print("show silo")
			show_speech(silo_subItem, silo)	
		
	emit_signal("playerSendCurrentHoldAmount", currentHoldAmount)
	
func dump_poo_in_silo():	
	if currentHoldAmount > 0:
		audio_ctrl.act(1) # the Poo drop sound
	
	gross_poo_harvested += currentHoldAmount
	
	totalPooAmount += currentHoldAmount
	currentHoldAmount = 0
	hud.update_global_poo_label(totalPooAmount)
	if totalPooAmount > 0:
		$GameOnTimer.start()

func _on_Player_body_entered(body):
	if (body.is_in_group("goblin")):
		steal_poo(body.stealAmount)
		body.start_StealTimer()

func steal_poo(stealAmount: int):
	currentHoldAmount = clamp(currentHoldAmount - stealAmount, 0, currentHoldAmount)	
	emit_signal("playerSendCurrentHoldAmount", currentHoldAmount)


func _on_Goblin_global_poo_stolen(stealAmount):
	totalPooAmount = max(0, totalPooAmount - stealAmount)
	hud.update_global_poo_label(totalPooAmount)

func show_speech(subitem, target):
	for item in subItems:
		if (is_instance_valid(item)):
			item.visible = false
	if (is_instance_valid(subitem)):
		subitem.visible = true
		speech.visible = true
		$SpeechTimer.start()
	if (is_instance_valid(target)):
		#rotate arrow handle towards target
		var angle = self.global_position.angle_to_point(target.global_position)
		print("Angle to target: " + str(rad2deg(angle)))
		arrow_handle.rotation = (angle)

func _on_SpeechTimer_timeout():
	speech.visible = false

func game_over():	
	get_tree().paused = true
	var enemy_spawner = get_tree().get_nodes_in_group("spawner_enemy")[0]
	print("You Poose!")
	var wave_count = "Waves survived: " + str(clamp(enemy_spawner.wave_count - 1, 0, enemy_spawner.wave_count)) + ", nice!"
	var gross_poo = "You harvested " + str(gross_poo_harvested) + " poo with your hands.... gross..."
	$ModalWindow.display_game_over(wave_count, gross_poo)

func _on_GameOnTimer_timeout():
	if totalPooAmount <= 0:
		game_over()


func reset():
	position = Vector2(1406, 1619)
	currentHoldAmount = 0
	totalPooAmount = 0
	fireModes = [FireMode.values.Shovel]
	equippedFireMode = FireMode.values.Shovel
	$GameOnTimer.stop()
	


func _firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode):
	emit_signal("firePoo", pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)


func _on_shoot_enabled_changed(open):
	shoot_enabled = !open
