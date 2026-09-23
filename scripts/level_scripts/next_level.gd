extends BaseLevel

func _ready() -> void:
	super._ready()
	ConsoleLog.SCENE(true)


func _on_area_2d_area_entered(area: Area2D) -> void:
	SceneLoader.load_scene(self, "tutorial_level")
	SceneLoader.activate_scene(self, "tutorial_level")
