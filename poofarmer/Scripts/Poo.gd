extends Area2D
class_name Poo

@export var pooValue = 1
@export var _type = AnimalType.values.Chicken # (AnimalType.values)

var types_dict = {
	AnimalType.values.Chicken: 1, 
	AnimalType.values.Goat: 2,
	AnimalType.values.Cow: 3,
	AnimalType.values.Llama: 4,
	AnimalType.values.Unicorn: 10
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_type(type: int):
	_type = type as AnimalType.values
	pooValue = types_dict[_type]
	$AnimatedSprite2D.animation = "Unicorn" if (type == AnimalType.values.Unicorn) else "Normal"

func destroy():
	queue_free()

