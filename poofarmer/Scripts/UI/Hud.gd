extends Control

onready var arsenal_wheel = get_node("CanvasLayer/Arsenal Wheel")
onready var arsenal_wheel_anim = get_node("CanvasLayer/Arsenal Wheel/AnimationPlayer")
onready var silo_crud_points = $CanvasLayer/SiloCountContainer/SiloCrudPoints
onready var goblin_counter = $CanvasLayer/GoblinCountContainer/GoblinCountLabel
var arsenal_pressed: bool = false

func _ready():
	arsenal_wheel.rect_scale = Vector2(0, 0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("open_arsenal") and !arsenal_pressed:
			arsenal_pressed = true
			arsenal_wheel_anim.playback_speed = 8
			arsenal_wheel_anim.play("arsenal_open")
			Engine.time_scale = 0.2
		if event.is_action_released("open_arsenal") and arsenal_pressed:
			arsenal_pressed = false
			arsenal_wheel_anim.playback_speed = 1
			arsenal_wheel_anim.play("arsenal_close")
			Engine.time_scale = 1


func update_global_poo_label(totalPooAmount):
	silo_crud_points.text = str(totalPooAmount)

func update_global_goblin_label(totalGoblins):
	goblin_counter.text = str(totalGoblins)
