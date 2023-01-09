extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func act_store_music_transition(opened: bool):
	if opened:
		play("Main To Shop")
	else:
		play_backwards("Main To Shop")

func _on_Store_close_store():
	act_store_music_transition(false)

func _on_Store_open_store():
	act_store_music_transition(true)
