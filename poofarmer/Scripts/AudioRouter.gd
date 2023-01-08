extends Node2D

onready var chicken_audio_ctrl = $ChickenAudioController
onready var cow_audio_ctrl = $CowAudioController
onready var goat_audio_ctrl = $GoatAudioController 
onready var llama_audio_ctrl = $LlamaAudioController
onready var unicorn_audio_ctrl = $UnicornAudioController


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Animal_action_enacted(animalType):
	var audio_controllers: Dictionary = {
		AnimalType.values.Chicken: chicken_audio_ctrl,
		AnimalType.values.Goat: goat_audio_ctrl,
		AnimalType.values.Cow: cow_audio_ctrl,
		AnimalType.values.Llama: llama_audio_ctrl,
		AnimalType.values.Unicorn: unicorn_audio_ctrl,
	}
	
	var controller: MobAudioController = audio_controllers[animalType]
	controller.act(randi() % controller.actions.size())
