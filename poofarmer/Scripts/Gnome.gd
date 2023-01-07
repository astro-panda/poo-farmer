extends Area2D

var player_in_range = false

onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Gnome_area_entered(body: Node):
	if(body.is_in_group("player")):
		sprite.animation = "glow"
		player_in_range = true


func _on_Gnome_area_exited(body: Node):	
	if(body.is_in_group("player")):
		sprite.animation = "default"
		player_in_range = false


func _unhandled_input(event):
	var should_open_store = event is InputEventMouseButton && (event as InputEventMouseButton).button_index == 1 && player_in_range && event.is_pressed()
	if(should_open_store):
		print("clicky clicky");
