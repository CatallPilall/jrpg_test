extends Node2D
class_name BaseLevel

@onready var player_spawn_position: Node2D = $player_spawn_position

var player_character_packed_scene : PackedScene = preload("res://scenes/player_scenes/player_character.tscn")
var player_character : CharacterBody2D

func _init() -> void:
	ConsoleLog.DEBUG("TEST INIT BASE_LEVEL BASE SCENE")
	EventBus.connect_function_with_signal(self, _prepare_scene, EventBus.prepare_scene)


func _ready() -> void:
	ConsoleLog.SCENE(true)
	player_character = player_character_packed_scene.instantiate()
	player_spawn_position.add_child.call_deferred(player_character)
	SceneLoader.process_scene("level_hud", [], SceneLoader.SCENE_PROCESS_TYPE.ACTIVATE)


func _enter_tree() -> void:
	ConsoleLog.DEBUG("TEST ENTER TREE BASE_LEVEL")
	EventBus.connect_function_with_signal(self, _prepare_scene, EventBus.prepare_scene)

func _exit_tree() -> void:
	ConsoleLog.DEBUG("TEST EXIT TREE BASE_LEVEL")
	EventBus.disconnect_function_from_signal(self, _prepare_scene, EventBus.prepare_scene)


func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	ConsoleLog.ERROR("FUNCTION _prepare_scene() not aviable in child class (Level)")
	assert(false, "FUNCTION _prepare_scene() has to be overriden by child class")
