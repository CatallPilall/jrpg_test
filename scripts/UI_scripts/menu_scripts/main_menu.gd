extends Control

# var new_game_packed_scene : PackedScene = preload("res://scenes/UI_scenes/campaign_menu.tscn")

func _ready() -> void:
	ConsoleLog.SCENE(true)

func _on_new_button_pressed() -> void:
	ConsoleLog.INPUT("New_Game_Button", "pressed", [])
	# var new_game : Control = new_game_packed_scene.instantiate()
	# var new_game : Control = SceneLoader.load_scene(SceneLoader.SCENE_TYPE.CAMPAIGN_MENU) as Control
	# ConsoleLog.DEBUG(self, "load_ui_scene : " + str(new_game))
	SceneLoader.load_scene(self, "campaign_menu")
	SceneLoader.activate_scene(self, "campaign_menu")

func _on_exit_button_pressed() -> void:
	ConsoleLog.INPUT("Exit_Game_Button", "pressed", [])
	get_tree().quit()
