extends Node

class_name Main

@onready var menu_canvas_layer: CanvasLayer = $menu_canvas_layer
@onready var hud_canvas_layer: CanvasLayer = $hud_canvas_layer

@onready var combat_scenes: Node = $combat_scenes
@onready var level_scenes: Node = $level_scenes

@onready var timer: Timer = $global_timer

func _ready() -> void:
	ConsoleLog.SCENE(true)

	TimerGlobal.init_timer(timer)
	SceneLoader.init_vars(self, menu_canvas_layer, hud_canvas_layer, combat_scenes, level_scenes)
	# SceneLoader.connect_signals()
	# SceneLoader.load_scene(SceneLoader.SCENE_TYPE.MAIN_MENU)
	SceneLoader.load_scene(self, "main_menu")
	SceneLoader.activate_scene(self, "main_menu")
