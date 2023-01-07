extends Area2D


signal playerFire(playerPosition, fireAngle)

# Declare member variables here. Examples:
export var speed = 300
export var holdCapacity = 10
var currentHoldAmount = 0
var totalPooAmount = 0
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = Vector2(2048, 2048)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.x > 0:
		print("play right animation")
	elif velocity.x < 0:
		print("play left animation")
	elif velocity.y > 0:
		print("play up animation")
	elif velocity.y < 0:
		print ("play down animation")

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerSprite.play()
	else:
		$PlayerSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
		
func _unhandled_input(event):
	if event.is_action_pressed("player_fire"):
		var clickLocation = get_global_mouse_position()
		var fireAngle = rad2deg(clickLocation.angle_to_point(position))
		emit_signal("playerFire", position, fireAngle)
		print("fire from ", position, " at an angle of ", fireAngle)


func _on_Player_body_entered(body):
	# TODO: Have a check that the body object is in a poo group
	if (currentHoldAmount < holdCapacity):
		currentHoldAmount += 1
		totalPooAmount += 1
		print("grabbed a poo")
