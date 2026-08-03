extends Control

var test_level_packed_scene : PackedScene = preload("res://scenes/level_scenes/test_level.tscn")

func _ready() -> void:
	ConsoleLog.SCENE(self,true)


func _on_brunhilde_button_pressed() -> void:
	ConsoleLog.INPUT("Bruhilde_Button","pressed",[self])
	var test_level : Node2D = test_level_packed_scene.instantiate()
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"load_scene","emit",new_signal_key)
	EventBus.load_scene.emit(test_level,new_signal_key)
