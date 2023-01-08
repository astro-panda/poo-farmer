extends Path2D


# Declare member variables here. Examples:
onready var gnome = $PathFollow2D/Gnome as Gnome
onready var pathFollow = $PathFollow2D
export var speed = 20
var isMoving = true
var previousPosition: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	previousPosition = gnome.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isMoving:
		pathFollow.set_offset(pathFollow.get_offset() + speed * delta)
		var deltaX = previousPosition.x - gnome.global_position.x
		var deltaY = previousPosition.y - gnome.global_position.y
		if deltaX > 0.08:
			gnome.playAnimation("left")
		elif deltaX < -0.08:
			gnome.playAnimation("right")
		elif deltaY > 0:
			gnome.playAnimation("up")
		elif deltaY < 0:
			gnome.playAnimation("down")
		previousPosition = gnome.global_position
