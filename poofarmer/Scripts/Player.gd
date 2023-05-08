extends KinematicBody2D
class_name Player

signal firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)
signal playerSendCurrentHoldAmount(currentHoldAmount)
signal update_global_poo_label(dump_amount)
signal game_on()

# Declare member variables here. Examples:
export (PackedScene) var poo_pellets
export var speed = 250
var screen_size
var shoot_enabled = true

var fireModes = [FireMode.values.Shovel]
export(FireMode.values) var equippedFireMode = FireMode.values.Shovel

onready var hud = get_tree().get_nodes_in_group("hud")[0]
onready var silo = get_tree().get_nodes_in_group("silo")[0]
var goboSpawner

onready var modal_window = $ModalWindow
onready var game_on_timer = $GameOnTimer
onready var audio_ctrl = $MobAudioController
onready var speech = $PlayerSprite/SpeechBubble
onready var arrow_handle = $PlayerSprite/SpeechBubble/ArrowHandle
onready var arsenal = $PooterArsenal

onready var silo_subItem = $PlayerSprite/SpeechBubble/Silo

onready var goboSpeech = $PlayerSprite/GoboSpeechBubble
onready var goboArrowHandle = $PlayerSprite/GoboSpeechBubble/ArrowHandle
var gobodarOverride = false

var subItems = [silo_subItem]

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = Vector2(3072, 3072)

func _physics_process(_delta):	
	if shoot_enabled && Input.is_action_pressed("player_fire"):
		arsenal.shoot()
		
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
		if Input.is_action_just_pressed("deep_pockets"):
			arsenal.infinite_ammo = !arsenal.infinite_ammo
		if Input.is_action_just_pressed("shovel"):
			arsenal.select_weapon(FireMode.values.Shovel)
		if Input.is_action_just_pressed("pistol"):
			arsenal.select_weapon(FireMode.values.Pistol)
		if Input.is_action_just_pressed("shatgun"):
			arsenal.select_weapon(FireMode.values.Shatgun)
		if Input.is_action_just_pressed("scatling"):
			arsenal.select_weapon(FireMode.values.Scatling)
		if Input.is_action_just_pressed("launcher"):
			arsenal.select_weapon(FireMode.values.RocketLauncher)
		if Input.is_action_just_pressed("railgun"):
			arsenal.select_weapon(FireMode.values.Railgun)
		if Input.is_action_just_pressed("gobodar"):
			gobodarOverride = !gobodarOverride
		
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
	
	var goboCount = goboSpawner.get_enemy_count()
	var threshold = ceil(goboSpawner.current_population / 10.0)
	if (goboCount > 0) && (goboSpawner.doneSpawning && goboCount <= threshold || gobodarOverride):
		goboSpeech.visible = true
		var closestGoblin = goboSpawner.get_enemy_list()[0]
		var distToClosestGoblin = global_position.distance_to(closestGoblin.global_position)
		for goblin in goboSpawner.get_enemy_list():
			var distToGoblin = global_position.distance_to(goblin.global_position)
			if distToGoblin < distToClosestGoblin:
				closestGoblin = goblin
				distToClosestGoblin = distToGoblin
		var angle = goboArrowHandle.global_position.angle_to_point(closestGoblin.global_position)
		goboArrowHandle.rotation = angle
	else:
		goboSpeech.visible = false
		
	if (GlobalState.player_current_hold_amount >= GlobalState.player_hold_Capacity):
		show_speech(silo_subItem, silo)
	else:
		speech.visible = false


func _on_Area2D_area_entered(body):
	if (body.is_in_group("poo")):
		if (GlobalState.player_current_hold_amount < GlobalState.player_hold_Capacity):
			var poo = body as Poo
			var pooToAdd = clamp(poo.pooValue, 0, GlobalState.player_hold_Capacity - GlobalState.player_current_hold_amount)
			GlobalState.player_current_hold_amount += pooToAdd		
			audio_ctrl.act(0) # the Poo pick up sound
			if(pooToAdd != poo.pooValue):
				poo.pooValue -= pooToAdd
			else:
				var goblins = get_tree().get_nodes_in_group("goblin")
				for node in goblins:
					var goblin = node as Goblin
					goblin.removePooFromTargets(body, false)
				poo.destroy()
		
	emit_signal("playerSendCurrentHoldAmount", GlobalState.player_current_hold_amount)
	
func dump_poo_in_silo():	
	if GlobalState.player_current_hold_amount > 0:
		audio_ctrl.act(1) # the Poo drop sound
	
	GlobalState.total_poo_collected += GlobalState.player_current_hold_amount
	
	GlobalState.total_poo_amount += GlobalState.player_current_hold_amount
	GlobalState.player_current_hold_amount
	hud.update_global_poo_label(GlobalState.total_poo_amount)
	if GlobalState.total_poo_amount > 0:
		$GameOnTimer.start()

func _on_Player_body_entered(body):
	if (body.is_in_group("goblin")):
		steal_poo(body.stealAmount)
		body.start_StealTimer()

func steal_poo(stealAmount: int):
	GlobalState.player_current_hold_amount = clamp(GlobalState.player_current_hold_amount - GlobalState.goblin_steal_amount, 0, GlobalState.player_current_hold_amount)	
	emit_signal("playerSendCurrentHoldAmount", GlobalState.player_current_hold_amount)


func _on_Goblin_global_poo_stolen(stealAmount):
	GlobalState.total_poo_amount = max(0, GlobalState.total_poo_amount - GlobalState.goblin_steal_amount)

func show_speech(subitem, target):
	for item in subItems:
		if (is_instance_valid(item)):
			item.visible = false
	if (is_instance_valid(subitem)):
		subitem.visible = true
		speech.visible = true
	if (is_instance_valid(target)):
		#rotate arrow handle towards target
		var angle = arrow_handle.global_position.angle_to_point(target.global_position)
		arrow_handle.rotation = angle

func game_over():
	get_tree().paused = true
	var enemy_spawner = get_tree().get_nodes_in_group("spawner_enemy")[0]
	var wave_count = "Waves survived: " + str(clamp(enemy_spawner.wave_count - 1, 0, enemy_spawner.wave_count)) + ", nice!"
	var gross_poo = "You harvested " + str(GlobalState.total_poo_collected) + " poo with your hands.... gross..."
	$ModalWindow.display_game_over(wave_count, gross_poo)

func _on_GameOnTimer_timeout():
	if GlobalState.total_poo_amount <= 0:
		game_over()

func reset():
	position = Vector2(1406, 1619)
	fireModes = [FireMode.values.Shovel]
	equippedFireMode = FireMode.values.Shovel
	$GameOnTimer.stop()

func _firePoo(pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode):
	emit_signal("firePoo", pelletInstance, spawnPosition, angleToMouse, mouseClick, fireMode)


func _on_shoot_enabled_changed(open):
	shoot_enabled = !open
