extends KinematicBody2D

signal action_enacted(animalType)

export(float) var poo_timer_min = 4.0
export(float) var poo_timer_max = 20.0
export var speed = 1500

export(AnimalType.values) var _type = AnimalType.values.Chicken

onready var poo_timer = $PooTimer
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var pooSpawner = get_tree().get_nodes_in_group("poo_spawner")[0]

var destination: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	destination = Vector2(randi() % 1024, randi() % 1024)
	reset_poo_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	velocity = (destination - position).normalized() * speed * delta
	velocity = move_and_slide(velocity)
	if (position.distance_to(destination) < 100):
		destination = Vector2(randi() % 1024, randi() % 1024)


func reset_poo_timer():
	poo_timer.wait_time = rand_range(poo_timer_min, poo_timer_max) as float
	poo_timer.start()


func do_poo():	
	pooSpawner.do_poo(self)	
	emit_signal("action_enacted", _type)
	reset_poo_timer()

func set_type(type:AnimalType):
	_type = type.current_value
	print("Animal Type Selected: " + AnimalType.values.keys()[_type])
	$Sprite.animation = AnimalType.values.keys()[_type] + " - down"
	print(_type)
	
