extends Node

enum SCENE_PROCESS_TYPE {
	NONE,
	LOAD,
	UNLOAD,
	ACTIVATE,
	DEACTIVATE,
	SHOW,
	HIDE,
	PAUSE,
	RESUME,
}

## Dictionary, dass die SCENE_TYPEs den entsprechenden Nodes zuordnet, an die die Szenen angehängt werden sollen
## READ ONLY: Die Nodes werden von Main.gd übergeben und dürfen nicht verändert werden
var scene_types_main_nodes : Dictionary[SceneDB.SCENE_TYPE, Node] = {
	SceneDB.SCENE_TYPE.MENU : null,
	SceneDB.SCENE_TYPE.HUD : null,
	SceneDB.SCENE_TYPE.NPC_OVERLAY : null,
	SceneDB.SCENE_TYPE.LEVEL : null,
	SceneDB.SCENE_TYPE.COMBAT : null
}

var is_initialized : bool = false

var scene_db : SceneDB

# var return_chain : Array[Node] = []


func _init() -> void:
	scene_db = SceneDB.new()


func _check_initialization() -> bool:
	if not is_initialized:
		ConsoleLog.ERROR(
			"SceneLoader has not been initialized. "
			+ "Please call init_vars() from Main.gd before using SceneLoader."
		)
	return is_initialized


## Initalisierung der Variablen, die von Main.gd übergeben werden;
## Zu übergebene Nodes befinden sich im Main Node
func init_vars(called_by : Object, _menu_canvas_layer : CanvasLayer, _hud_canvas_layer : CanvasLayer, _npc_overlay_canvas_layer : CanvasLayer, _combat_scenes : Node, _level_scenes : Node) -> void:
	if called_by.get_script().get_global_name() != "Main":
		ConsoleLog.ERROR(
			"SceneLoader.init_vars() can only be called from Main.gd"
		)
		return
	scene_types_main_nodes[SceneDB.SCENE_TYPE.MENU] = _menu_canvas_layer
	scene_types_main_nodes[SceneDB.SCENE_TYPE.HUD] = _hud_canvas_layer
	scene_types_main_nodes[SceneDB.SCENE_TYPE.NPC_OVERLAY] = _npc_overlay_canvas_layer
	scene_types_main_nodes[SceneDB.SCENE_TYPE.COMBAT] = _combat_scenes
	scene_types_main_nodes[SceneDB.SCENE_TYPE.LEVEL] = _level_scenes

	scene_db.load_all_resources()
	scene_db.instantiate_all_scenes()

	is_initialized = true



func _switch_scene_same_scene_type(scene_data : SceneData, arguments : Array = []):
	if scene_types_main_nodes[scene_data.is_scene_type].get_child_count() > 0:
		var scene_to_deactivate : SceneData = scene_db.get_active_scenedata_by_type(scene_data.is_scene_type)
		_scene_activation(scene_to_deactivate, false)

	_scene_activation(scene_data, true, arguments)


func _scene_activation(scene_data : SceneData, activate: bool, arguments : Array = []) -> void:
	scene_db.set_scenedata_activation_by_name(scene_data.scene_name, activate)

	if activate:
		EventBus.emit_signal_log(EventBus.prepare_scene, [scene_data.instantiated_node, arguments])
		scene_types_main_nodes[scene_data.is_scene_type].add_child.call_deferred(scene_data.instantiated_node)
	else:
		scene_types_main_nodes[scene_data.is_scene_type].remove_child.call_deferred(scene_data.instantiated_node)


## Mögliche Werte für load_type: [br]
## SCENE_PROCESS_TYPE.LOAD, [br]
## SCENE_PROCESS_TYPE.UNLOAD, [br]
## SCENE_PROCESS_TYPE.ACTIVATE, [br]
## SCENE_PROCESS_TYPE.DEACTIVATE, [br]
## SCENE_PROCESS_TYPE.SHOW, [br]
## SCENE_PROCESS_TYPE.HIDE, [br]
## SCENE_PROCESS_TYPE.PAUSE, [br]
## SCENE_PROCESS_TYPE.RESUME [br]
func process_scene(scene_name : String, arguments : Array = [], load_type : SCENE_PROCESS_TYPE = SCENE_PROCESS_TYPE.NONE) -> void:
	if not scene_db.is_scene_aviable(scene_name):
		return

	var scene_is_active : bool = true if scene_db.is_scene_active(scene_name) else false
	var scene_is_loaded : bool = true if scene_db.is_scene_loaded(scene_name) else false

	match load_type:
		SCENE_PROCESS_TYPE.LOAD:
			if scene_is_loaded:
				return
			ConsoleLog.DEBUG("Loading scene: " + scene_name)
		SCENE_PROCESS_TYPE.UNLOAD:
			if not scene_is_loaded:
				return
			ConsoleLog.DEBUG("Unloading scene: " + scene_name)
		SCENE_PROCESS_TYPE.ACTIVATE:
			if scene_is_active:
				return
			ConsoleLog.DEBUG("Activating scene: " + scene_name)

			var scene_data : SceneData = scene_db.get_scenedata_by_name(scene_name)
			_switch_scene_same_scene_type(scene_data, arguments)



		SCENE_PROCESS_TYPE.DEACTIVATE:
			if not scene_is_active:
				return
			ConsoleLog.DEBUG("Deactivating scene: " + scene_name)

			var scene_data : SceneData = scene_db.get_active_scenedata_by_name(scene_name)
			_scene_activation(scene_data, false)



		SCENE_PROCESS_TYPE.SHOW:
			if not scene_is_active:
				return
			ConsoleLog.DEBUG("Showing scene: " + scene_name)
			scene_db.set_scenedata_hidden_by_name(scene_name, false)
		SCENE_PROCESS_TYPE.HIDE:
			if not scene_is_active:
				return
			ConsoleLog.DEBUG("Hiding scene: " + scene_name)
			scene_db.set_scenedata_hidden_by_name(scene_name, true)
		SCENE_PROCESS_TYPE.PAUSE:
			if not scene_is_active:
				return
			ConsoleLog.DEBUG("Pausing scene: " + scene_name)
			scene_db.set_scenedata_paused_by_name(scene_name, true)
		SCENE_PROCESS_TYPE.RESUME:
			if not scene_is_active:
				return
			ConsoleLog.DEBUG("Resuming scene: " + scene_name)
			scene_db.set_scenedata_paused_by_name(scene_name, false)
		_:
			ConsoleLog.ERROR("No valid SCENE_PROCESS_TYPE provided for scene: " + scene_name)


## Mögliche Werte für load_type: [br]
## SCENE_PROCESS_TYPE.UNLOAD, [br]
## SCENE_PROCESS_TYPE.DEACTIVATE, [br]
## SCENE_PROCESS_TYPE.SHOW, [br]
## SCENE_PROCESS_TYPE.HIDE, [br]
## SCENE_PROCESS_TYPE.PAUSE, [br]
## SCENE_PROCESS_TYPE.RESUME [br]
func process_active_scene(active_scene_type : SceneDB.SCENE_TYPE, arguments : Array = [], load_type : SCENE_PROCESS_TYPE = SCENE_PROCESS_TYPE.NONE) -> void:
	if not scene_db.is_scene_type_active(active_scene_type):
		return

	var active_scene_data : SceneData = scene_db.get_active_scenedata_by_type(active_scene_type)

	match load_type:
		SCENE_PROCESS_TYPE.UNLOAD:
			ConsoleLog.DEBUG("Unloading scene for type: " + scene_db.enum_to_string_scene_type(active_scene_type))
		SCENE_PROCESS_TYPE.DEACTIVATE:
			ConsoleLog.DEBUG("Deactivating scene for type: " + scene_db.enum_to_string_scene_type(active_scene_type))
			_scene_activation(active_scene_data, false, arguments)
		SCENE_PROCESS_TYPE.SHOW:
			ConsoleLog.DEBUG("Showing scene for type: " + scene_db.enum_to_string_scene_type(active_scene_type))
			scene_db.set_scenedata_hidden_by_type(active_scene_type, false)
		SCENE_PROCESS_TYPE.HIDE:
			ConsoleLog.DEBUG("Hiding scene for type: " + scene_db.enum_to_string_scene_type(active_scene_type))
			scene_db.set_scenedata_hidden_by_type(active_scene_type, true)
		SCENE_PROCESS_TYPE.PAUSE:
			ConsoleLog.DEBUG("Pausing scene for type: " + scene_db.enum_to_string_scene_type(active_scene_type))
			scene_db.set_scenedata_paused_by_type(active_scene_type, true)
		SCENE_PROCESS_TYPE.RESUME:
			ConsoleLog.DEBUG("Resuming scene for type: " + scene_db.enum_to_string_scene_type(active_scene_type))
			scene_db.set_scenedata_paused_by_type(active_scene_type, false)
		_:
			ConsoleLog.ERROR("No valid SCENE_PROCESS_TYPE provided for active scene: " + scene_db.enum_to_string_scene_type(active_scene_type))
