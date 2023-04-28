extends Node2D

@onready var chicken_audio_ctrl = $ChickenAudioController
@onready var cow_audio_ctrl = $CowAudioController
@onready var goat_audio_ctrl = $GoatAudioController 
@onready var llama_audio_ctrl = $LlamaAudioController
@onready var unicorn_audio_ctrl = $UnicornAudioController

var audio_controllers:Dictionary
var target_controller: MobAudioController

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_controllers = {
		AnimalType.values.Chicken: chicken_audio_ctrl,
		AnimalType.values.Goat: goat_audio_ctrl,
		AnimalType.values.Cow: cow_audio_ctrl,
		AnimalType.values.Llama: llama_audio_ctrl,
		AnimalType.values.Unicorn: unicorn_audio_ctrl,
	}


func initialize_router(animalType):	
	target_controller = audio_controllers[animalType]
	target_controller.enabled = true

func _on_Animal_action_enacted():
	target_controller.act(randi() % target_controller.actions.size())
