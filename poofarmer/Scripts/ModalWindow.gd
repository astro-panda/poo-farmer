extends Control

signal game_reset
signal game_quit

onready var canvas = $CanvasLayer
onready var poosed = $CanvasLayer/Poosed
onready var how_to_play = $CanvasLayer/HowToPlay
onready var game_over = $CanvasLayer/GameOver

var game_started = false
var is_paused = false

func _ready():
	reset_canvas()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		set_is_paused(!is_paused)


func set_is_paused(value):	
	if game_started:
		if value:
			show_poosed()
		else:
			reset_canvas()
		get_tree().paused = value
		is_paused = value


func display_game_over():
	set_is_paused(true)
	canvas.visible = true
	poosed.visible = false
	how_to_play.visible = false
	game_over.visible = true


func show_poosed():
	canvas.visible = true 
	poosed.visible = true
	how_to_play.visible = false
	game_over.visible = false


func show_how_to_play():
	canvas.visible = true
	poosed.visible = false
	how_to_play.visible = true
	game_over.visible = false


func reset_canvas():	
	canvas.visible = false
	poosed.visible = false
	how_to_play.visible = false
	game_over.visible = false


func trigger_game_reset():
	unpause()
	emit_signal("game_reset")
	
func quit_game():
	reset_canvas()
	set_is_paused(true)
	game_started = false
	emit_signal("game_quit")

func _on_StartScreen_game_started():
	game_started = true
	unpause()
	
func unpause():
	reset_canvas()
	set_is_paused(false)
