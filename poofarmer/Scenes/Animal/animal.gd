extends RigidBody2D

export(float) var poo_timer_min = 4
export(float) var poo_timer_max = 20

onready var poo_timer = $PooTimer



# Called when the node enters the scene tree for the first time.
func _ready():	
	reset_poo_timer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func reset_poo_timer():
	poo_timer.wait = rand_range(poo_timer_min, poo_timer_max)
	poo_timer.start()
	
func do_poo():
	pass
