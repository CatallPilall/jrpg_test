extends Node

class_name Main

@onready var main_canvas_layer: CanvasLayer = $MainCanvasLayer
@onready var timer: Timer = $global_timer

@onready var combat_scenes: Node = $combat_scenes
@onready var level_scenes: Node = $level_scenes


func _ready() -> void:
	ConsoleLog.SCENE(self,true)

	SceneLoader.init_vars(self, main_canvas_layer, combat_scenes, level_scenes)
	TimerGlobal.set_timer(timer)
	connect_signals()
	SceneLoader.load_main_menu()


func connect_signals():
	EventBus.connect_function_with_signal(SceneLoader.load_ui_scene, EventBus.load_ui_scene)
	EventBus.connect_function_with_signal(SceneLoader.load_scene, EventBus.load_scene)
	EventBus.connect_function_with_signal(SceneLoader.load_hud_scene, EventBus.load_hud_scene)
	EventBus.connect_function_with_signal(SceneLoader.load_combat_scene, EventBus.load_combat_scene)
	EventBus.connect_function_with_signal(SceneLoader.unload_combat_scene, EventBus.unload_combat_scene)

	EventBus.connect_function_with_signal(TimerGlobal.set_and_start_timer, EventBus.set_and_start_timer)
	EventBus.connect_function_with_signal(TimerGlobal.start_default_timer, EventBus.start_default_timer)
	EventBus.connect_function_with_signal(TimerGlobal.pause_timer, EventBus.pause_timer)
	EventBus.connect_function_with_signal(TimerGlobal.unpause_timer, EventBus.unpause_timer)
