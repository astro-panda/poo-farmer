extends Area2D
class_name Gnome

signal store_opened(opened)

@onready var sprite = $AnimatedSprite2D
@onready var glow = $AnimatedSprite2D/Glow
@onready var player = get_tree().get_nodes_in_group("player")[0]

var player_in_range = false

func _physics_process(_delta):
	player_in_range = overlaps_body(player)
	
	if player_in_range && Input.is_action_pressed("ui_select"):
		emit_signal("store_opened", true)


func playAnimation(direction):
	sprite.animation = direction
	glow.animation = direction
	glow.visible = player_in_range
