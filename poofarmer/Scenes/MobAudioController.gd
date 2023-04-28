extends Node
class_name MobAudioController

@export var next_behavior_min: float = 4.0
@export var next_behavior_max: float = 10.0
@export var enabled: bool = true

@export var actions: Array[AudioStream]
@export var behaviors: Array[AudioStream]

@onready var behavior_timer = $BehaviorTimer
@onready var behavior_player = $BehaviorAudioPlayer
@onready var action_player = $ActionAudioPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pause()
	reset_behavior_timer()

func reset_behavior_timer():
	behavior_timer.wait_time = randf_range(next_behavior_min, next_behavior_max) as float
	behavior_timer.start()

func _on_BehaviorTimer_timeout():
	if behaviors.size() > 0 && enabled:	
		reset_behavior_timer()	
		var behavior: AudioStream = behaviors[randi() % behaviors.size()]	
		behavior_player.stream = behavior
		behavior_player.play()

func act(index: int):
	if enabled:
		var action: AudioStream = actions[clamp(index, 0, actions.size())]
		action_player.stream = action
		action_player.play()
	
func play():
	action_player.playing = true
	behavior_player.playing = true
	
func pause():
	action_player.playing = false
	behavior_player.playing = false
