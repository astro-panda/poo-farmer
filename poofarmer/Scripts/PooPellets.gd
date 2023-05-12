extends Area2D


export(float) var poo_speed = 10.0
export(FireMode.values) var fire_mode
var damage
var distance
var direction := Vector2.ZERO
var startLocation
var willExplode: bool = false
var exploding: bool
var explodeSize = 10
var explodeOverride = false
var isRailShot = false
var rotateAngle

func _ready():
	if isRailShot:
		scale.x = 0.5
		scale.y = 100
		$AnimatedSprite.position.y += -5
		$CollisionShape2D.position.y += -5
		rotation_degrees = rad2deg(rotateAngle - (PI / 2))
		$RailShotTimer.start()

func _physics_process(_delta: float) -> void:
	if direction != Vector2.ZERO && !isRailShot:
		var distTraveled = global_position.distance_to(startLocation)
		var velocity = direction * poo_speed
		if !exploding:
			global_position += velocity
		if distTraveled >= distance || explodeOverride:
			if willExplode:
				if !exploding:
					exploding = true
				start_explode()
				scale.x += 0.4
				scale.y += 0.4
				if scale.x >= explodeSize || scale.y >= explodeSize:
					queue_free()
			else:
				queue_free()

func set_direction(new_direction: Vector2):
	direction = new_direction

func _on_PooPellets_body_entered(body):
	if body.has_method("handle_hit"):
		if willExplode:
			explodeOverride = true

		if !willExplode && !isRailShot && !body.is_dying:
			queue_free()
			
		body.handle_hit(damage, self)

func start_explode():
	if !$Exploder.playing:
		$Exploder.play()

func _on_RailShotTimer_timeout():
	queue_free()
