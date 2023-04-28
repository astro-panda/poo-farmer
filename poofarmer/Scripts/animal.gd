extends CharacterBody2D

signal action_enacted(animalType)

@export var poo_timer_min: float = 4.0
@export var poo_timer_max: float = 20.0
@export var destination_timer_min: float = 4.0
@export var destination_timer_max: float = 15.0
@export var speed = 1500
@export var corked: bool = false

@export var _type = AnimalType.values.Chicken # (AnimalType.values)

@onready var poo_timer = $PooTimer
@onready var destination_timer = $ChangeDestinationTimer
@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var pooSpawner = get_tree().get_nodes_in_group("poo_spawner")[0]
@onready var silo = get_tree().get_nodes_in_group("silo")[0]
@onready var audio_router = $AudioRouter
var rnd = RandomNumberGenerator.new()

var angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ChangeDestinationTimer_timeout()
	reset_poo_timer()
	audio_router.initialize_router(_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vector_from_angle = Vector2.RIGHT.rotated(angle).normalized()
	velocity = vector_from_angle * speed * delta
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	# Keep unicorns away from the silo and all animals from getting hung up on it
	if ((position.distance_to(silo.position) < 1000 && _type == AnimalType.values.Unicorn)) || position.distance_to(silo.position) < 115:
		angle = position.angle_to_point(silo.position)
		
	if global_position.x < 72 || global_position.x > 3000:
		angle = PI - angle
	if global_position.y < 72 || global_position.y > 3000:
		angle = (2 * PI) - angle
	
	var unit_angle = angle
	while unit_angle > (2 * PI):
		unit_angle -= (2 * PI)
	while unit_angle < 0:
		unit_angle += (2 * PI)
	
	if unit_angle < (PI / 3) || unit_angle > (5 * PI / 3):
		$Sprite2D.animation = AnimalType.values.keys()[_type] + " - right"
	elif unit_angle > (2 * PI / 3) && unit_angle < (4 * PI / 2):
		$Sprite2D.animation = AnimalType.values.keys()[_type] + " - left"
	elif unit_angle > (PI / 3) && unit_angle < (2 * PI / 3):
		$Sprite2D.animation = AnimalType.values.keys()[_type] + " - down"
	elif unit_angle > (4 * PI / 3) && unit_angle < (5 * PI / 3):
		$Sprite2D.animation = AnimalType.values.keys()[_type] + " - up"


func reset_poo_timer():
	poo_timer.wait_time = randf_range(poo_timer_min, poo_timer_max) as float
	poo_timer.start()


func do_poo():	
	if !corked:
		pooSpawner.do_poo(self)
	emit_signal("action_enacted")
	reset_poo_timer()

func set_type(type:AnimalType):
	_type = type.current_value as AnimalType.values
	$Sprite2D.animation = AnimalType.values.keys()[_type] + " - down"	


func _on_ChangeDestinationTimer_timeout():
	angle = rnd.randf_range(angle - (PI/3), angle + (PI/3))
	destination_timer.start(randf_range(destination_timer_min, destination_timer_max))
