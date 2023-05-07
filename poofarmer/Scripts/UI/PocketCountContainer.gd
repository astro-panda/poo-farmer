extends NinePatchRect

onready var pocket_crud_progress = $PocketCrudProgressBar

func _ready():
	pocket_crud_progress.max_value = GlobalState.player_hold_Capacity

func _process(_delta):
	pocket_crud_progress.value = GlobalState.player_current_hold_amount
