extends NinePatchRect

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var pocket_crud_progress = $PocketCrudProgressBar

func _ready():
	pocket_crud_progress.max_value = player.holdCapacity

func _process(_delta):
	pocket_crud_progress.value = player.currentHoldAmount
