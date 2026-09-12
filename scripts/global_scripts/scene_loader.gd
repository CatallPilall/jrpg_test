extends Node

var main_canvas_layer : CanvasLayer

var combat_scenes: Node
var level_scenes: Node

var current_ui_scene : Control
var current_hud_scene : Control
var current_scene : Node2D
var current_combat_scene : combat_scene

var main_menu_packed_scene : PackedScene = preload("res://scenes/UI_scenes/main_menu.tscn")

var is_initialized : bool = false


func _init() -> void:
	# This function is called when the node is initialized.
	# You can perform any necessary setup here.
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _check_initialization() -> bool:
	if not is_initialized:
		ConsoleLog.ERROR(self, "SceneLoader 27", "SceneLoader has not been initialized. Please call init_vars() from Main.gd before using SceneLoader.")
		return false
	return true


## Initalisierung der Variablen, die von Main.gd übergeben werden;
## Zu übergebene Nodes befinden sich im Main Node
func init_vars(_called_by : Object, _main_canvas_layer : CanvasLayer, _combat_scenes : Node, _level_scenes : Node) -> void:
	if _called_by.get_script().get_global_name() != "Main":
		ConsoleLog.ERROR(self, "SceneLoader 35", "SceneLoader.init_vars() can only be called from Main.gd")
		return
	main_canvas_layer = _main_canvas_layer
	combat_scenes = _combat_scenes
	level_scenes = _level_scenes

	is_initialized = true


# func connect_signals() -> void:
# 	if not _check_initialization():
# 		return

# 	EventBus.connect_function_with_signal(load_ui_scene, EventBus.load_ui_scene)
# 	EventBus.connect_function_with_signal(load_scene, EventBus.load_scene)
# 	EventBus.connect_function_with_signal(load_hud_scene, EventBus.load_hud_scene)
# 	EventBus.connect_function_with_signal(load_combat_scene, EventBus.load_combat_scene)
# 	EventBus.connect_function_with_signal(unload_combat_scene, EventBus.unload_combat_scene)


func load_main_menu() -> void:
	if not _check_initialization():
		return
	var new_main_menu : Control = main_menu_packed_scene.instantiate()
	current_ui_scene = new_main_menu
	main_canvas_layer.add_child(new_main_menu)
	ConsoleLog.DEBUG(self, "load_main_menu")


func load_pause_menu() -> void:
	if not _check_initialization():
		return
	ConsoleLog.DEBUG(self, "load_pause_menu")


func load_combat_scene(scene : combat_scene):
	if not _check_initialization():
		return
	current_scene.hide()
	current_combat_scene = scene
	combat_scenes.add_child.call_deferred(current_combat_scene)
	ConsoleLog.DEBUG(self, "load_combat_scene")


func unload_combat_scene(overworld_encounter : Node2D):
	if not _check_initialization():
		return
	overworld_encounter.queue_free()
	current_combat_scene.queue_free()
	current_combat_scene = null
	current_scene.show()
	ConsoleLog.DEBUG(self, "unload_combat_scene")


func load_ui_scene(ui_scene : Control):
	if not _check_initialization():
		return

	if current_ui_scene != null:
		current_ui_scene.queue_free()
		ConsoleLog.SCENE(current_ui_scene, false)
	if current_scene != null:
		current_scene.queue_free()
		ConsoleLog.SCENE(current_scene, false)
		current_scene = null
	if current_hud_scene != null:
		current_hud_scene.queue_free()
		ConsoleLog.SCENE(current_hud_scene, false)
		current_hud_scene = null
	current_ui_scene = ui_scene
	main_canvas_layer.add_child.call_deferred(ui_scene)
	ConsoleLog.DEBUG(self, "load_ui_scene")


func load_hud_scene(hud_scene : Control):
	if not _check_initialization():
		return

	if current_hud_scene != null:
		current_hud_scene.queue_free()
		ConsoleLog.SCENE(current_hud_scene, false)
	else:
		current_hud_scene = hud_scene
		main_canvas_layer.add_child.call_deferred(hud_scene)
	ConsoleLog.DEBUG(self, "load_hud_scene")


func load_scene(scene : Node2D):
	if not _check_initialization():
		return

	if current_scene != null:
		current_scene.queue_free()
		ConsoleLog.SCENE(current_scene, false)
	if current_ui_scene != null:
		current_ui_scene.queue_free()
		ConsoleLog.SCENE(current_ui_scene, false)
		current_ui_scene = null
	if current_hud_scene != null:
		current_hud_scene.queue_free()
		ConsoleLog.SCENE(current_hud_scene, false)
		current_hud_scene = null
	current_scene = scene
	level_scenes.add_child.call_deferred(scene)
	ConsoleLog.DEBUG(self, "load_scene")
