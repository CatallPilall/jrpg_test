extends Node

class_name Main

@onready var main_canvas_layer: CanvasLayer = $MainCanvasLayer
@onready var timer: Timer = $global_timer

@onready var combat_scenes: Node = $combat_scenes
@onready var level_scenes: Node = $level_scenes


func _ready() -> void:
	ConsoleLog.SCENE(self,true)

	TimerGlobal.set_timer(timer)
	SceneLoader.init_vars(self, main_canvas_layer, combat_scenes, level_scenes)
	# SceneLoader.connect_signals()
	SceneLoader.load_main_menu()
