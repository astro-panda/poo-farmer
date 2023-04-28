extends Node
@export var poo_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func do_poo(animal):	
	var poo = poo_scene.instantiate()
	poo.position = animal.position
	poo.set_type(animal._type)
	add_child(poo)
