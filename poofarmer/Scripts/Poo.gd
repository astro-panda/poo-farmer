extends Area2D
class_name Poo

signal collided

export var pooValue = 1
export(AnimalType.values) var _type = AnimalType.values.Chicken

var types_dict = {
	AnimalType.values.Chicken: 1, 
	AnimalType.values.Goat: 2,
	AnimalType.values.Cow: 3,
	AnimalType.values.Llama: 4,
	AnimalType.values.Unicorn: 10
}

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func set_type(type: AnimalType):
	_type = type.current_value
	pooValue = types_dict[_type]
	$AnimatedSprite.animation = AnimalType.values.keys()[_type]
	show()

func destroy():
	queue_free()

func _on_Poo_body_entered(body):
	emit_signal("collided")
