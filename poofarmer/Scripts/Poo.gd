extends Area2D

signal collided

export var pooValue = 1
onready var Animal = get_node("/root/Animal")
var _type: Animal

var types_dict = {
	Animal.Chicken: 1, 
	Animal.Goat: 2,
	Animal.Cow: 3,
	Animal.Llama: 4,
	Animal.Unicorn: 10
}

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func set_type(type: Animal):
	_type = type
	pooValue = types_dict[_type]
	$AnimatedSprite.animation = Animal.keys()[_type]
	show()

func destroy():
	queue_free()

func _on_Poo_body_entered(body):
	emit_signal("collided")
