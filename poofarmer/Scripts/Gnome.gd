extends Area2D
class_name Gnome

signal store_opened(opened)

onready var sprite = $AnimatedSprite
onready var glow = $AnimatedSprite/Glow

var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _unhandled_input(event):	
	var should_open_store = event is InputEventMouseButton && (event as InputEventMouseButton).button_index == 1 && player_in_range && event.is_pressed()
	if should_open_store:
		emit_signal("store_opened", true)
	elif event.is_action_pressed("store"):
		emit_signal("store_opened", false)

func _on_Gnome_area_entered(body: Node):
	if(body.is_in_group("player")):
		player_in_range = true


func _on_Gnome_area_exited(body: Node):	
	if(body.is_in_group("player")):
		player_in_range = false

func playAnimation(direction):
	sprite.animation = direction
	glow.animation = direction
	glow.visible = player_in_range
