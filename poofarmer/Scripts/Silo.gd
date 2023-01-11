extends Area2D

onready var player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if overlaps_body(player):
		#$SiloSprite.animation = "open-doors"
		print("player in dump range")
		
		if Input.is_action_pressed("ui_select"):
			(player as Player).dump_poo_in_silo()
