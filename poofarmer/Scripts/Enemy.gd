extends KinematicBody2D
class_name Enemy

signal global_poo_stolen(stealAmount)
signal enemy_killed

export var speed = 4000
export var fleeSpeedMultiplier = 4
export var health = 4
export var stealAmount = 3
export var siloStealAmount = 5
onready var silo = get_tree().get_nodes_in_group("silo")[0]
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var audio_ctrl = $MobAudioController
onready var hit_feedback_timer = $HitFeedbackTimer
var sprite
var sprite_scale
var isFleeing = false
var fleeingVector = Vector2(0,0)
var is_dying = false
var hit_color = Color(100, 100, 100, 1)
var normal_color = Color(1, 1, 1)

func _ready():
	hit_feedback_timer.connect("timeout", self, "reset_sprite_after_hit")


func detected_something(area, player_steal):
	if !is_dying:
		if (area.is_in_group("poo")):
			destroy_poo(area)
		
		if (area.is_in_group("silo")):
			emit_signal("global_poo_stolen", siloStealAmount)
			isFleeing = true
			
		if area.is_in_group("player") && GlobalState.player_current_hold_amount > 0 && player_steal:
			isFleeing = true
			player.steal_poo(stealAmount)
			audio_ctrl.act(0)

func destroy_poo(poo):
	if (poo.is_in_group("poo")):
		var pooInstance = poo as Poo
		pooInstance.destroy()

func steal_from_player():
	player.steal_poo(stealAmount)
	audio_ctrl.act(0)
		
func move_at_body(body, delta):
	var velocity = (body.position - position).normalized() * speed * delta * (fleeSpeedMultiplier if isFleeing else 1)
	return move_and_slide(velocity)

func enemy_handle_hit(damage, sprite_offset, poo):
	if !is_dying:
		health -= damage
		if health <= 0:
			if sprite.animation == "right":
				sprite.flip_h = true
			sprite.offset.y = sprite_offset
			sprite.play("death")
			is_dying = true
		else:
			sprite.self_modulate = hit_color
			sprite.scale = sprite_scale + Vector2(0.1, 0.1)
			sprite.offset = poo.global_position.direction_to(global_position).normalized() * 2
			hit_feedback_timer.start()


func calculate_sprite_direction(velocity):
	if velocity.x > 0:
		sprite.animation = "right"
	elif velocity.x < 0:
		sprite.animation = "left"
	elif velocity.y > 0:
		sprite.animation = "down"
	elif velocity.y < 0:
		sprite.animation = "up"

func end_death():
	if sprite.animation == "death":
		queue_free()
		emit_signal("enemy_killed")

func reset_sprite_after_hit():
	sprite.self_modulate = normal_color
	sprite.scale = sprite_scale
	sprite.offset = Vector2(0,0)
