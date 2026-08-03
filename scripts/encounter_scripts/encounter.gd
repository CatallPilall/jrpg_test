extends Node2D

class_name encounter

var combat_scene_packed_scene : PackedScene = preload("res://scenes/combat_scenes/combat_scene.tscn")

var enemy_one : Node2D

func initiate_combat():
	var new_combat_scene : combat_scene = combat_scene_packed_scene.instantiate()
	new_combat_scene.enemy_one = enemy_one
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"load_scene","emit",new_signal_key)
	EventBus.load_scene.emit(new_combat_scene,new_signal_key)
