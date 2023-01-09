extends Node

onready var poo_pellets_manager = $PooPelletsManager
onready var player = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player.connect("playerFire", poo_pellets_manager, "handle_poo_pellets")
