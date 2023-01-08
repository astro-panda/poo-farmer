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
	behavior_timer.start()


func _on_BehaviorTimer_timeout():
	reset_behavior_timer()	
	var behavior: AudioStream = behaviors[randi() % behaviors.size()]
	behavior_player.stream = behavior
	behavior_player.play()

func act(index: int):
	action_player.stop()
	var action: AudioStream = actions[clamp(index, 0, actions.size())]
	action_player.stream = action
	action_player.play()
