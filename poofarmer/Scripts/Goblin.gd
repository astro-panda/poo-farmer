extends KinematicBody2D
class_name Goblin

# Declare member variables here. Examples:
export var speed = 1000
var silo
var currentPooTargets = []
var health = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	silo = get_tree().current_scene.get_node("Silo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if currentPooTargets.size() == 0:
		velocity = (silo.position - position).normalized() * speed * delta
		velocity = move_and_slide(velocity)
	else:
		velocity = (currentPooTargets[0].position - position).normalized() * speed * delta
		velocity = move_and_slide(velocity)
		
	if velocity.x > 0:
		$AnimatedSprite.animation = "right"
	elif velocity.x < 0:
		$AnimatedSprite.animation = "left"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"


func _on_Visibility_area_entered(area):
	if (area.is_in_group("poo")):
		currentPooTargets.append(area)


func _on_PooPickupDetection_area_entered(area):
	removePooFromTargets(area, true)
		
func removePooFromTargets(poo, destroy):
	if (poo.is_in_group("poo")):
		var pooInstance = poo as Poo
		currentPooTargets.erase(poo)
		if (destroy):
			pooInstance.destroy()
