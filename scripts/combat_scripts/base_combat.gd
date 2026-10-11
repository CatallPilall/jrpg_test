extends Node2D
class_name BaseCombat

func _init() -> void:
	ConsoleLog.DEBUG("TEST INIT BASE_COMBAT BASE SCENE")
	EventBus.connect_function_with_signal(self, _prepare_scene, EventBus.prepare_scene)


func _ready() -> void:
	ConsoleLog.SCENE(true)


func _enter_tree() -> void:
	ConsoleLog.DEBUG("TEST ENTER TREE BASE_COMBAT")
	# EventBus.connect_function_with_signal(self, _prepare_scene, EventBus.prepare_scene)


func _exit_tree() -> void:
	ConsoleLog.DEBUG("TEST EXIT TREE BASE_COMBAT")
	# EventBus.disconnect_function_from_signal(self, _prepare_scene, EventBus.prepare_scene)


func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	# Spezifische aufrufe für combat sind hier -> muss im child explizit aufgerufen werden
	# HUD und Level sind bound an den Combat wenn er aktiviert wird
	SceneLoader.process_active_scene(SceneDB.SCENE_TYPE.LEVEL, [], SceneLoader.SCENE_PROCESS_TYPE.DEACTIVATE)
	SceneLoader.process_scene("combat_hud", [], SceneLoader.SCENE_PROCESS_TYPE.ACTIVATE)
