extends BaseUI

# var new_game_packed_scene : PackedScene = preload("res://scenes/UI_scenes/campaign_menu.tscn")

func _ready() -> void:
	ConsoleLog.SCENE(true)

func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	if called_node == self:
		ConsoleLog.DEBUG("HEHEO AUFGERUFEN IN MAIN_MENU PREPARE_SCENE")

func _on_new_button_pressed() -> void:
	ConsoleLog.INPUT("New_Game_Button", "pressed", [])
	# var new_game : Control = new_game_packed_scene.instantiate()
	# var new_game : Control = SceneLoader.load_scene(SceneLoader.SCENE_TYPE.CAMPAIGN_MENU) as Control
	# ConsoleLog.DEBUG(self, "load_ui_scene : " + str(new_game))
	# SceneLoader.process_scene("campaign_menu", [], SceneLoader.SCENE_PROCESS_TYPE.LOAD)
	SfxPlayer.play_sound("ui_click")
	SceneLoader.process_scene("campaign_menu", ["test", 3, "noch etwas test"], SceneLoader.SCENE_PROCESS_TYPE.ACTIVATE)

func _on_exit_button_pressed() -> void:
	ConsoleLog.INPUT("Exit_Game_Button", "pressed", [])
	SfxPlayer.play_sound("ui_click")
	get_tree().quit()
