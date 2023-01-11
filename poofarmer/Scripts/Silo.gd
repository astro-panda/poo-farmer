extends Area2D

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var barn_sprite = $BarnSprite

func _physics_process(delta):
	if overlaps_body(player):
		barn_sprite.animation = "open-doors"
		print("player in dump range")
		
		if Input.is_action_pressed("ui_select"):
			(player as Player).dump_poo_in_silo()
	else:
		barn_sprite.animation = "closed-doors"
