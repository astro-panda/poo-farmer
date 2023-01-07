extends NinePatchRect

onready var pocket_crud_progress = get_node("PocketCrudProgressBar")
onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	pocket_crud_progress.max_value = player.holdCapacity
	player.connect("playerSendCurrentHoldAmount", self, "_on_player_hold_amount_changed")

func _on_player_hold_amount_changed(var holdAmount):
	pocket_crud_progress.value = holdAmount
