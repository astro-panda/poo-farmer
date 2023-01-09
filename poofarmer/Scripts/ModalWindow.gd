extends Control

onready var canvas = $CanvasLayer

var game_started = false

var is_paused = false setget set_is_paused

func _ready():
	visible = false	


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		!is_paused

func set_is_paused(value):
	if game_started:
		get_tree().paused = value	
		is_paused = value
		canvas.visible = value	
	
func _on_StartButton_pressed():
	game_started = true
	set_is_paused(false)


func display_game_over():
	set_is_paused(true)
	print("Wire up game over UI here")


func _on_StartScreen_how_to_play_requested():
	canvas.visible = true
