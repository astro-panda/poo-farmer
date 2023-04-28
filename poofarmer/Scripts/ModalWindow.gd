extends Control

signal game_reset
signal game_quit
signal game_paused
signal game_resumed

@onready var canvas = $CanvasLayer
@onready var poosed = $CanvasLayer/Poosed
@onready var how_to_play = $CanvasLayer/HowToPlay
@onready var game_over = $CanvasLayer/GameOver
@onready var click_player = $ClickPlayer

@onready var wave_banner = $"CanvasLayer/GameOver/Wave Banner"
@onready var poo_banner = $"CanvasLayer/GameOver/Poo Banner"

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
		click()


func display_game_over(waves: String, pooCollected: String):
	set_is_paused(true)
	
	wave_banner.text = waves
	poo_banner.text = pooCollected
	canvas.visible = true
	poosed.visible = false
	how_to_play.visible = false
	game_over.visible = true


func show_poosed():
	canvas.visible = true 
	poosed.visible = true
	how_to_play.visible = false
	game_over.visible = false
	emit_signal("game_paused")


func show_how_to_play():
	canvas.visible = true
	poosed.visible = false
	how_to_play.visible = true
	game_over.visible = false


func reset_canvas():
	click()
	canvas.visible = false
	poosed.visible = false
	how_to_play.visible = false
	game_over.visible = false
	emit_signal("game_resumed")


func trigger_game_reset():	
	unpause()
	emit_signal("game_reset")
	
func quit_game():
	click()
	reset_canvas()
	game_started = false
	set_is_paused(true)
	emit_signal("game_quit")

func _on_StartScreen_game_started():
	game_started = true
	unpause()
	
func unpause():
	click()
	reset_canvas()
	set_is_paused(false)
	
func click():
	click_player.play()
