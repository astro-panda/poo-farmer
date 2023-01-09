extends Control

signal arsenal_state_changed(open)

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var arsenal_wheel = get_node("CanvasLayer/Arsenal Wheel")
onready var arsenal_wheel_anim = get_node("CanvasLayer/Arsenal Wheel/AnimationPlayer")
onready var silo_crud_points = $CanvasLayer/SiloCountContainer/SiloCrudPoints
onready var goblin_counter = $CanvasLayer/GoblinCountContainer/GoblinCountLabel
onready var canvas_layer = $CanvasLayer
onready var click_player = $ClickPlayer
onready var shovelBtn = $"CanvasLayer/Arsenal Wheel/Shovel"
onready var pistolBtn = $"CanvasLayer/Arsenal Wheel/Pistol"
onready var shatgunBtn = $"CanvasLayer/Arsenal Wheel/Shatgun"
onready var scatlingBtn = $"CanvasLayer/Arsenal Wheel/ScatlingGun"
onready var rocketLauncherBtn = $"CanvasLayer/Arsenal Wheel/RocketLauncher"
onready var railgunBtn = $"CanvasLayer/Arsenal Wheel/Railgun"
onready var listOfButtons = [shovelBtn, pistolBtn, shatgunBtn, rocketLauncherBtn, scatlingBtn, railgunBtn]
var arsenal_pressed: bool = false
const grayedOutColor = Color(0.305882, 0.305882, 0.305882)
const normalColor = Color(1, 1, 1)

func _ready():
	arsenal_wheel.rect_scale = Vector2(0, 0)
	for btn in listOfButtons:
		btn.disabled = true
		btn.get_node("TextureRect").modulate = grayedOutColor

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("open_arsenal") and !arsenal_pressed:
			check_weapons()
			arsenal_pressed = true
			arsenal_wheel_anim.playback_speed = 8
			arsenal_wheel_anim.play("arsenal_open")
			Engine.time_scale = 0.2
		if event.is_action_released("open_arsenal") and arsenal_pressed:
			arsenal_pressed = false
			arsenal_wheel_anim.playback_speed = 1
			arsenal_wheel_anim.play("arsenal_close")
			Engine.time_scale = 1
		
	emit_signal("arsenal_state_changed", arsenal_pressed)


func update_global_poo_label(totalPooAmount):
	silo_crud_points.text = str(totalPooAmount)

func update_global_goblin_label(totalGoblins):
	goblin_counter.text = str(totalGoblins)

func showHUD(show: bool):
	canvas_layer.visible = show

func _on_Store_update_global_poo_label(totalPooAmount):
	update_global_poo_label(totalPooAmount)

func check_weapons():
	for i in listOfButtons.size():
		for fireMode in player.fireModes:
			listOfButtons[int(fireMode)].disabled = false
			listOfButtons[int(fireMode)].get_node("TextureRect").modulate = normalColor


func _on_Shovel_pressed():
	if player.fireModes.has(FireMode.values.Shovel):
		player.equippedFireMode = FireMode.values.Shovel
		click()


func _on_Pistol_pressed():
	if player.fireModes.has(FireMode.values.Pistol):
		player.equippedFireMode = FireMode.values.Pistol
		click()


func _on_Shatgun_pressed():
	if player.fireModes.has(FireMode.values.Shatgun):
		player.equippedFireMode = FireMode.values.Shatgun
		click()


func _on_ScatlingGun_pressed():
	if player.fireModes.has(FireMode.values.Scatling):
		player.equippedFireMode = FireMode.values.Scatling
		click()


func _on_RocketLauncher_pressed():
	if player.fireModes.has(FireMode.values.RocketLauncher):
		player.equippedFireMode = FireMode.values.RocketLauncher
		click()


func _on_Railgun_pressed():
	if player.fireModes.has(FireMode.values.Railgun):
		player.equippedFireMode = FireMode.values.Railgun
		click()


func click():
	click_player.play()
	get_tree().set_input_as_handled()
