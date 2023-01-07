extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ModalWindow_game_play_state_changed(playing: bool):
	if !playing:
		play("Poose Screen")


func _on_Gnome_store_opened(opened: bool):
	if opened:
		play("Main To Shop")
	else:
		play_backwards("Main To Shop")

