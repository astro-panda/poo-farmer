extends Node


export var player_hold_Capacity = 10
export var goblin_steal_amount = 5
export var player_current_hold_amount = 0
export var total_poo_amount = 0
export var total_poo_collected = 0


func reset():
	total_poo_amount = 0
	total_poo_collected = 0
	player_current_hold_amount = 0	
