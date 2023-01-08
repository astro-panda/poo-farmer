extends Node


export(PackedScene) var animal_scene
export var population: int
onready var player = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	population = 20
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	var animalType = AnimalType.new()
	print("AnimalType Count: " + str(AnimalType.values.keys().size()))
	animalType.current_value = (randi() % AnimalType.values.keys().size())
	print("Random number was: " + str(randi()))
	print("Current Value: " + str(AnimalType.values.keys()[animalType.current_value]))
	var animal = animal_scene.instance()
#	TODO: get a better position for the animal spawn
	animal.position = player.get_position()
	animal.set_type(animalType)
	add_child(animal)
	if(get_child_count() > population):
		$SpawnTimer.stop()
