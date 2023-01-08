extends Node


export(PackedScene) var animal_scene
export var population = 10
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var camera = get_tree().get_nodes_in_group("camera")[0]
var rnd = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	var animalType = AnimalType.new()
	animalType.current_value = (randi() % AnimalType.values.keys().size())
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
	print("spawned animal at ", animal.position)
	animal.set_type(animalType)
	add_child(animal)
	if(get_child_count() > population):
		$SpawnTimer.stop()
