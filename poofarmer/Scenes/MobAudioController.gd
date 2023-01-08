extends Node
class_name MobAudioController

export(float) var next_behavior_min = 4.0
export(float) var next_behavior_max = 10.0

export(Array, AudioStream) var actions
export(Array, AudioStream) var behaviors

onready var behavior_timer = $BehaviorTimer
onready var behavior_player = $BehaviorAudioPlayer
onready var action_player = $ActionAudioPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_behavior_timer()


func reset_behavior_timer():
	behavior_timer.wait_time = rand_range(next_behavior_min, next_behavior_max) as float
	behavior_
