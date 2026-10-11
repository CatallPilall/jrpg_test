extends BaseUI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	if called_node == self:
		ConsoleLog.DEBUG("HEHEO AUFGERUFEN IN LEVEL_HUD PREPARE_SCENE")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
