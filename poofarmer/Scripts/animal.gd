extends RigidBody2D

export(float) var poo_timer_min = 4.0
export(float) var poo_timer_max = 20.0
export(PackedScene) var poo_scene
onready var Animal = get_node("/root/Animal")

var _type: Animal

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

func set_type(type:Animal):
	_type = type
	$AnimatedSprite.animation = Animal.keys()[_type]
	show()
