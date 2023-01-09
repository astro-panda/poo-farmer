extends Control

signal how_to_play_requested

onready var canvas = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	pass # Replace with function body.


func _on_Start_pressed():
	get_tree().call_group("start_animal","queue_free")
	get_tree().paused = false
	canvas.visible = false


func _on_How_to_Play_pressed():
	emit_signal("how_to_play_requested")

