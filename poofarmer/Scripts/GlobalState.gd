extends Node


export var player_hold_Capacity: float = 10.0
export var goblin_steal_amount = 5.0
export var player_current_hold_amount: float  = 0.0
export var total_poo_amount: float  = 0
export var total_poo_collected: float  = 0

func reset():
	total_poo_amount = 0
	total_poo_collected = 0
	player_current_hold_amount = 0	
