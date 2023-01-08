extends NinePatchRect

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var pocket_crud_progress = $PocketCrudProgressBar

func _ready():
	pocket_crud_progress.max_value = player.holdCapacity
	player.connect("playerSendCurrentHoldAmount", self, "_on_player_hold_amount_changed")

func _on_player_hold_amount_changed(var holdAmount):
	pocket_crud_progress.value = holdAmount
