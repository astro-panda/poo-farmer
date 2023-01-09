extends Control

signal game_started
signal how_to_play_requested

onready var canvas = $CanvasLayer

func _ready():
	begin()


func begin():
	get_tree().paused = true
	canvas.visible = true


func _on_Start_pressed():
	get_tree().call_group("start_animal","queue_free")
	get_tree().paused = false
	canvas.visible = false
	emit_signal("game_started")


func _on_How_to_Play_pressed():
	emit_signal("how_to_play_requested")

