extends BaseLevel

func _ready() -> void:
	super._ready()
	ConsoleLog.SCENE(true)


func _on_area_2d_area_entered(_area: Area2D) -> void:
	# SceneLoader.process_scene(self, "tutorial_level", [], SceneLoader.SCENE_PROCESS_TYPE.LOAD)
	SceneLoader.process_scene("tutorial_level", [], SceneLoader.SCENE_PROCESS_TYPE.ACTIVATE)


func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	if called_node == self:
		ConsoleLog.DEBUG("HEHEO AUFGERUFEN IN NEXT_LEVEL PREPARE_SCENE")
