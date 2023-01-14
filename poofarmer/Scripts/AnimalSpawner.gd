extends Node


export(PackedScene) var animal_scene
export var population = 10
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var camera = get_tree().get_nodes_in_group("camera")[0]
var rnd = RandomNumberGenerator.new()
export(bool) var spawn_animals = true
var number_of_unicorns = 0
export var max_number_of_unicorns = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	if spawn_animals:
		var animalType = AnimalType.new()
		animalType.current_value = (randi() % AnimalType.values.keys().size())
		if animalType.current_value == 4:
			number_of_unicorns += 1
		if number_of_unicorns >= (max_number_of_unicorns + 1):
			# never spawn more than 2 unicorns
			return
			
		var animal = animal_scene.instance()
		
		var cameraWidth = 640
		var cameraHeight = 375
		var cameraPosition = camera.get_camera_position()
		var cameraTop = cameraPosition.y - (cameraHeight / 2)
		var cameraBottom = cameraPosition.y + (cameraHeight / 2)
		var cameraLeft = cameraPosition.x - (cameraWidth / 2)
		var cameraRight = cameraPosition.x + (cameraWidth / 2)
		
		var spawnX = rnd.randi_range(0, 3072)
		var spawnY = rnd.randi_range(0, 3072)
		while (spawnX > cameraLeft) && (spawnX < cameraRight) && (spawnY > cameraTop) && (spawnY < cameraBottom):
			spawnX = rnd.randi_range(0, 3072)
			spawnY = rnd.randi_range(0, 3072)
		
		animal.position = Vector2(spawnX, spawnY)
		animal.set_type(animalType)
		add_child(animal)
		if(get_child_count() > population):
			$SpawnTimer.stop()
