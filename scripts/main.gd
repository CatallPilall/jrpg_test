extends Node

class_name Main

@onready var menu_canvas_layer: CanvasLayer = $menu_canvas_layer
@onready var hud_canvas_layer: CanvasLayer = $hud_canvas_layer
@onready var npc_overlay_canvas_layer: CanvasLayer = $npc_overlay_canvas_layer

@onready var combat_scenes: Node = $combat_scenes
@onready var level_scenes: Node = $level_scenes

@onready var bgm_player: AudioStreamPlayer = $bgm_player
@onready var action_sfx_player: AudioStreamPlayer = $action_sfx_player

# @onready var timer: Timer = $global_timer

func _ready() -> void:
	ConsoleLog.SCENE(true)

	SfxPlayer.init_vars(action_sfx_player)
	MusicPlayer.init_vars(bgm_player)

	MusicPlayer.set_loop(true)
	MusicPlayer.play_sound("ambient_4", 2.5)

	SceneLoader.init_vars(self, menu_canvas_layer, hud_canvas_layer, npc_overlay_canvas_layer, combat_scenes, level_scenes)
	SceneLoader.process_scene("main_menu", [], SceneLoader.SCENE_PROCESS_TYPE.ACTIVATE)
