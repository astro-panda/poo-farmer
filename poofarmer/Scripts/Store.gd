extends Control

signal close_store
signal open_store

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var camera = get_tree().get_nodes_in_group("camera")[0]
onready var hud = get_tree().get_nodes_in_group("hud")[0]
onready var click_player = $ClickPlayer
onready var canvas = $CanvasLayer
onready var pooCount = $CanvasLayer/TotalPooContainer/TotalPooCount
onready var pistolButton = $CanvasLayer/Pistol
onready var shatgunButton = $CanvasLayer/Shotgun
onready var rocketLauncherButton = $CanvasLayer/RocketLauncher
onready var scatlingButton = $CanvasLayer/Scatling
onready var railgunButton = $CanvasLayer/Railgun
onready var listOfButtons = [pistolButton, shatgunButton, rocketLauncherButton, scatlingButton, railgunButton]
const listOfCosts = [10, 20, 40, 60, 100]
const grayedOutColor = Color(0.305882, 0.305882, 0.305882)
const normalColor = Color(1, 1, 1)


func _ready():
	show_store(false)
	for i in listOfButtons.size():
		listOfButtons[i].get_node("Label").text = str(listOfCosts[i])

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		show_store(false)

func _on_Gnome_store_opened(opened):
	if opened:
		check_btns()
		hud.showHUD(false)
		pooCount.text = str(player.totalPooAmount)
		show_store(true)
		
func check_btns():
	for j in listOfButtons.size():
		change_button_state(j, player.totalPooAmount <= listOfCosts[j], true)
	for fireMode in player.fireModes:
		if fireMode != FireMode.values.Shovel:
			change_button_state(int(fireMode) - 1, true, false)

func change_button_state(idx: int, disabled: bool, hideLabel: bool):
	click()
	var btnNode = listOfButtons[idx].get_node("Button")
	listOfButtons[idx].get_node("AnimatedSprite").modulate = grayedOutColor if disabled else normalColor
	btnNode.modulate = grayedOutColor if disabled else normalColor
	btnNode.disabled = disabled
	listOfButtons[idx].get_node("Label").visible = hideLabel

func _on_PistolButton_button_down():
	buy_item(FireMode.values.Pistol)
	
func _on_ShotgunButton_button_down():
	buy_item(FireMode.values.Shatgun)

func _on_RocketLauncherButton_button_down():
	buy_item(FireMode.values.RocketLauncher)

func _on_ScatlingButton_button_down():
	buy_item(FireMode.values.Scatling)

func _on_RailgunButton_button_down():
	buy_item(FireMode.values.Railgun)

func buy_item(fireMode):
	var cost = listOfCosts[int(fireMode) - 1]
	if player.totalPooAmount > cost:
		player.fireModes.append(fireMode)
		player.totalPooAmount -= cost
		pooCount.text = str(player.totalPooAmount)
		hud.update_global_poo_label(player.totalPooAmount)
		change_button_state(int(fireMode) - 1, true, false)
		check_btns()

func _on_ExitButton_button_down():
	show_store(false)
	hud.showHUD(true)
	emit_signal("close_store")
	
func show_store(show: bool):
	click()
	canvas.visible = show
	if show:
		emit_signal("open_store")

func click():
	click_player.play()
