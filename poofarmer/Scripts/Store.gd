extends Control

signal close_store

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var camera = get_tree().get_nodes_in_group("camera")[0]
onready var pistolButton = $Pistol
onready var shatgunButton = $Shotgun
onready var rocketLauncherButton = $RocketLauncher
onready var scatlingButton = $Scatling
onready var railgunButton = $Railgun
onready var listOfButtons = [pistolButton, shatgunButton, rocketLauncherButton, scatlingButton, railgunButton]
const listOfCosts = [10, 20, 40, 60, 100]
const grayedOutColor = Color(0.305882, 0.305882, 0.305882)


func _ready():
	hide()
	for i in listOfButtons.size():
		listOfButtons[i].get_node("Label").text = str(listOfCosts[i])

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		hide()

func _on_Gnome_store_opened(opened):
	if opened:
		check_btns()
		self.set_global_position(camera.get_camera_position())
		show()
		
func check_btns():
	for j in listOfButtons.size():
		if player.totalPooAmount < listOfCosts[j]:
			_gray_out_button(j, true)
	for fireMode in player.fireModes:
		if fireMode != FireMode.values.Shovel:
			_gray_out_button(int(fireMode) - 1, false)

func _gray_out_button(idx: int, hideLabel: bool):
	var btnNode = listOfButtons[idx].get_node("Button")
	listOfButtons[idx].get_node("AnimatedSprite").modulate = grayedOutColor
	btnNode.modulate = grayedOutColor
	btnNode.disabled = true
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
	var playerpoo = player.totalPooAmount
	if player.totalPooAmount > cost:
		player.fireModes.append(fireMode)
		player.totalPooAmount -= cost
		_gray_out_button(int(fireMode) - 1, false)
		check_btns()

func _on_ExitButton_button_down():
	hide()
	emit_signal("close_store")
