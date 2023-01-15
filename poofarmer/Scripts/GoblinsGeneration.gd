extends Node

onready var hud = get_tree().get_nodes_in_group("hud")[0]
var num_enemies_killed = 0

func _ready():
	pass # Replace with function body.


func update_goblin_hud(total, wave, waitTime, waveCountdown):
	if waveCountdown:
		hud.update_global_goblin_label("Goblins Assembling", waveCountdown, waitTime, wave)
		num_enemies_killed = 0
	else:
		hud.update_global_goblin_label("Goblins " + str(total - num_enemies_killed) + " / " + str(total) + " Wave " + str(wave), false, 0, 0)


func _on_enemy_killed():
	num_enemies_killed += 1
	print("number enemies killed: ", num_enemies_killed)
