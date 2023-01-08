extends Control

signal game_play_state_changed(playing)

var is_paused = false setget set_is_paused

func _ready():
	visible = false
	

func _unhandled_input(event):
	if event.is_action_pressed("pause") || event.is_action_pressed("store"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	emit_signal("game_play_state_changed", !is_paused)
	
func _on_StartButton_pressed():
	self.is_paused = false
	emit_signal("game_play_state_changed", !is_paused)


func _on_Gnome_store_opened(opened):
	set_is_paused(opened)


func _on_Store_close_store():
	set_is_paused(false)
