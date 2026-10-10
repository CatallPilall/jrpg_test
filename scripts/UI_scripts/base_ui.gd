extends Control

class_name BaseUI


func _init() -> void:
	ConsoleLog.DEBUG("TEST INIT BASE_UI BASE SCENE")
	EventBus.connect_function_with_signal(self, _prepare_scene, EventBus.prepare_scene)

func _ready() -> void:
	pass

func _enter_tree() -> void:
	ConsoleLog.DEBUG("TEST ENTER TREE BASE_UI")
	EventBus.connect_function_with_signal(self, _prepare_scene, EventBus.prepare_scene)

func _exit_tree() -> void:
	ConsoleLog.DEBUG("TEST EXIT TREE BASE_UI")
	EventBus.disconnect_function_from_signal(self, _prepare_scene, EventBus.prepare_scene)

func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	ConsoleLog.ERROR("FUNCTION _prepare_scene() not aviable in child class (UI)")
	assert(false, "FUNCTION _prepare_scene() has to be overriden by child class")
