extends Control

var new_game_packed_scene : PackedScene = preload("res://scenes/UI_scenes/campaign_menu.tscn")

func _ready() -> void:
	ConsoleLog.SCENE(self,true)

func _on_new_button_pressed() -> void:
	ConsoleLog.INPUT("New_Game_Button","pressed",[self])
	var new_signal_key : int = EventBus.generate_signal_key()
	var new_game : Control = new_game_packed_scene.instantiate()
	ConsoleLog.SIGNAL(self,"load_ui_scene","emit",new_signal_key)
	EventBus.load_ui_scene.emit(new_game,new_signal_key)

func _on_exit_button_pressed() -> void:
	ConsoleLog.INPUT("Exit_Game_Button","pressed",[self])
	get_tree().quit()
