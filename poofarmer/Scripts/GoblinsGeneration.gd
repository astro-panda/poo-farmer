extends Node

onready var hud = get_tree().get_nodes_in_group("hud")[0]


func _ready():
	pass # Replace with function body.


func update_goblin_hud(total, wave):
	hud.update_global_goblin_label("Goblins " + str(self.get_child_count()) + " / " + str(total) + " Wave " + str(wave))
