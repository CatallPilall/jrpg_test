extends Node

var is_initialized : bool = false


## Dictionary, dass die SCENE_TYPEs den entsprechenden Nodes zuordnet, an die die Szenen angehängt werden sollen
## READ ONLY: Die Nodes werden von Main.gd übergeben und dürfen nicht verändert werden
var scene_types_main_nodes : Dictionary[SceneManager.SCENE_TYPE, Node] = {
	SceneManager.SCENE_TYPE.MENU : null,
	SceneManager.SCENE_TYPE.HUD : null,
	SceneManager.SCENE_TYPE.LEVEL : null,
	SceneManager.SCENE_TYPE.COMBAT : null
}


func _check_initialization() -> bool:
	if not is_initialized:
		ConsoleLog.ERROR(
			"SceneLoader has not been initialized. "
			+ "Please call init_vars() from Main.gd before using SceneLoader."
		)
	return is_initialized







func _add_child_scene():
	pass


func _remove_child_scene():
	pass


func _instantiate_scene():
	pass


func _queue_free_scene():
	pass









## Initalisierung der Variablen, die von Main.gd übergeben werden;
## Zu übergebene Nodes befinden sich im Main Node
func init_vars(called_by : Object, _menu_canvas_layer : CanvasLayer, _hud_canvas_layer : CanvasLayer, _combat_scenes : Node, _level_scenes : Node) -> void:
	if called_by.get_script().get_global_name() != "Main":
		ConsoleLog.ERROR(
			"SceneLoader.init_vars() can only be called from Main.gd"
		)
		return
	scene_types_main_nodes[SceneManager.SCENE_TYPE.MENU] = _menu_canvas_layer
	scene_types_main_nodes[SceneManager.SCENE_TYPE.HUD] = _hud_canvas_layer
	scene_types_main_nodes[SceneManager.SCENE_TYPE.COMBAT] = _combat_scenes
	scene_types_main_nodes[SceneManager.SCENE_TYPE.LEVEL] = _level_scenes

	is_initialized = true



func process_scene(arguments : Array, load_type : SceneManager.SCENE_PROCESS_TYPE, scene_type : SceneManager.SCENE_TYPE):
	pass
