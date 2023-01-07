extends RigidBody2D

export(float) var poo_timer_min = 4.0
export(float) var poo_timer_max = 20.0
export(PackedScene) var poo_scene

var _type

onready var poo_timer = $PooTimer

# Called when the node enters the scene tree for the first time.
func _ready():	
	hide()
	reset_poo_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func reset_poo_timer():
	poo_timer.wait_time = rand_range(poo_timer_min, poo_timer_max) as float
	poo_timer.start()	
	
func do_poo():	
	poo_timer.stop()
	print("Animal done pooed!💩💩💩💩");
	var poo = poo_scene.instance()
	poo.set_type(_type)
	reset_poo_timer()

func set_type(type:AnimalType):
	_type = type.current_value
	$AnimatedSprite.animation = AnimalType.values.keys()[_type]
	show()
