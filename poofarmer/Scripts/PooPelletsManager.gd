extends Node2D


func handle_poo_pellets(poo_pellets, position, direction):
	add_child(poo_pellets)
	poo_pellets.global_position = position
	poo_pellets.set_direction(direction)
