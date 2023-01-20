extends Node


var hand_point = load("res://Images/mouse-hand-point.png")
var hand_open = load("res://Images/mouse-hand-open.png")
var hand_closed = load("res://Images/mouse-hand-closed.png")
var crosshairs = load("res://Images/poo-crosshairs.png")
var current_mouse


func _ready():
	set_mouse_hand()
	
func _process(_delta):
	if Input.is_action_pressed("player_fire") && (current_mouse == hand_point || current_mouse == hand_open):
		Input.set_custom_mouse_cursor(hand_closed, Input.CURSOR_ARROW, Vector2(13, 0))
		current_mouse = hand_closed
		$ClickResetTimer.start()
	
func set_mouse_hand():
	Input.set_custom_mouse_cursor(hand_point, Input.CURSOR_ARROW, Vector2(13, 0))
	current_mouse = hand_point
	
func set_mouse_crosshairs():
	Input.set_custom_mouse_cursor(crosshairs, Input.CURSOR_ARROW, Vector2(31, 31))
	current_mouse = crosshairs

func _on_ClickResetTimer_timeout():
	if current_mouse == crosshairs:
		set_mouse_crosshairs()
	else:
		set_mouse_hand()
