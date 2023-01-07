extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 300
var silo
var currentPooTargets = []


# Called when the node enters the scene tree for the first time.
func _ready():
	silo = get_tree().current_scene.get_node("Silo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if currentPooTargets.count == 0:
		velocity = (silo.position - position).normalized * speed * delta
		velocity = move_and_slide(velocity)
	else:
		velocity = (currentPooTargets.pop_front().position - position).normalized * speed * delta
		velocity = move_and_slide(velocity)


func _on_Visibility_body_entered(body):
	if (body.is_in_group("poo")):
		currentPooTargets.push_back(body)
