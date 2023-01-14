extends KinematicBody2D

signal action_enacted(animalType)

export(float) var poo_timer_min = 4.0
export(float) var poo_timer_max = 20.0
export(float) var destination_timer_min = 5.0
export(float) var destination_timer_max = 15.0
export var speed = 1500
export(bool) var corked = false

export(AnimalType.values) var _type = AnimalType.values.Chicken

onready var poo_timer = $PooTimer
onready var destination_timer = $ChangeDestinationTimer
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var pooSpawner = get_tree().get_nodes_in_group("poo_spawner")[0]
onready var audio_router = $AudioRouter
var rnd = RandomNumberGenerator.new()

var topLeft = Vector2(0, 0)
var topRight = Vector2(3072, 0)
var bottomRight = Vector2(3072, 3072)
var bottomLeft = Vector2(0, 3072)
var halfOfDiagonal = 2173

var destination: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ChangeDestinationTimer_timeout()
	reset_poo_timer()
	audio_router.initialize_router(_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	velocity = (destination - position).normalized() * speed * delta
	velocity = move_and_slide(velocity)
	if (position.distance_to(destination) < 100):
		_on_ChangeDestinationTimer_timeout()
		
	if velocity.x > 4:
		$Sprite.animation = AnimalType.values.keys()[_type] + " - right"
	elif velocity.x < -4:
		$Sprite.animation = AnimalType.values.keys()[_type] + " - left"
	elif velocity.y > 0:
		$Sprite.animation = AnimalType.values.keys()[_type] + " - down"
	elif velocity.y < 0:
		$Sprite.animation = AnimalType.values.keys()[_type] + " - up"


func reset_poo_timer():
	poo_timer.wait_time = rand_range(poo_timer_min, poo_timer_max) as float
	poo_timer.start()


func do_poo():	
	if !corked:
		pooSpawner.do_poo(self)
	emit_signal("action_enacted")
	reset_poo_timer()

func set_type(type:AnimalType):
	_type = type.current_value
	$Sprite.animation = AnimalType.values.keys()[_type] + " - down"	


func _on_ChangeDestinationTimer_timeout():
	if _type == AnimalType.values.Unicorn:
		var rndSide = rnd.randi_range(0, 1)
		var rndLocAlongSide = rnd.randi_range(0, 3072)
		var rndDistFromSide = rnd.randi_range(0, 1000)
		var distToTopLeft = global_position.distance_to(topLeft)
		var distToTopRight = global_position.distance_to(topRight)
		var distToBottomRight = global_position.distance_to(bottomRight)
		if distToTopLeft < halfOfDiagonal:
			# Will be closest to Top Left
			if rndSide == 0:
				# Picked the left wall
				destination = Vector2(rndDistFromSide, rndLocAlongSide)
			else:
				# Picked the top wall
				destination = Vector2(rndLocAlongSide, rndDistFromSide)
		elif distToTopRight < halfOfDiagonal:
			# Will be closest to Top Right
			if rndSide == 0:
				# Picked the top wall
				destination = Vector2(rndLocAlongSide, rndDistFromSide)
			else:
				# Picked the right wall
				destination = Vector2(3072 - rndDistFromSide, rndLocAlongSide)
		elif distToBottomRight < halfOfDiagonal:
			# Will be closest to Bottom Right
			if rndSide == 0:
				# Picked the right wall
				destination = Vector2(3072 - rndDistFromSide, rndLocAlongSide)
			else:
				# Picked the bottom wall
				destination = Vector2(rndLocAlongSide, 3072 - rndDistFromSide)
		else:
			# Will be closest to Bottom Left
			if rndSide == 0:
				# Picked the bottom wall
				destination = Vector2(rndLocAlongSide, 3072 - rndDistFromSide)
			else:
				# Picked the left wall
				destination = Vector2(rndDistFromSide, rndLocAlongSide)
	else:
		destination = Vector2(rnd.randi_range(0, 3072), rnd.randi_range(0, 3072))
	destination_timer.start(rand_range(destination_timer_min, destination_timer_max))
