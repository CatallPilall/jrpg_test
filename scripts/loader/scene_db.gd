extends Object

class_name SceneDB

const RESOURCES_PATH_LEVELS : String = "res://resources/levels/"
const RESOURCES_PATH_COMBATS : String = "res://resources/combats/"
const RESOURCES_PATH_HUDS : String = "res://resources/uis/huds/"
const RESOURCES_PATH_MENUS : String = "res://resources/uis/menus/"
const RESOURCES_PATH_NPC_OVERLAYS : String = "res://resources/uis/npc_overlays/"

enum SCENE_TYPE {
	NONE,
	MENU,
	HUD,
	NPC_OVERLAY,
	LEVEL,
	COMBAT,
}

var scenedata_dictionary_all : Dictionary[String, SceneData]

var scene_types_current_active : Dictionary[SCENE_TYPE, SceneData] = {
	SCENE_TYPE.MENU : null,
	SCENE_TYPE.HUD : null,
	SCENE_TYPE.NPC_OVERLAY : null,
	SCENE_TYPE.LEVEL : null,
	SCENE_TYPE.COMBAT : null
}

var is_initialized : bool = false


func _check_initialization() -> bool:
	if not is_initialized:
		ConsoleLog.ERROR("SceneLoader has not been initialized.")
	return is_initialized


func enum_to_string_scene_type(scene_type : SCENE_TYPE) -> String:
	var key_name = SCENE_TYPE.find_key(scene_type)
	if key_name != null:
		return key_name
	return "UNKNOWN"


func _validate_scene_type(scene_type : SCENE_TYPE) -> bool:
	if not scene_types_current_active.has(scene_type):
		ConsoleLog.ERROR("Invalid scene type provided to get_active_scene_node_by_type()")
		return false
	return true


func _check_resource_exists(scene_name : String) -> bool:
	if scenedata_dictionary_all.has(scene_name):
		ConsoleLog.DEBUG("Resource found: " + scene_name)
		return true
	else:
		ConsoleLog.ERROR("Resource not found: " + scene_name)
		return false


func _load_resources_from_path(path : String) -> Dictionary[String, SceneData]:
	var resource_dict : Dictionary[String, SceneData] = {}

	for resource_name in DirAccess.open(path).get_files():
		if resource_name.ends_with(".tres"):
			var resource_to_load = load(path + resource_name)
			var scene_type = resource_to_load.is_scene_type
			resource_to_load.scene_name = resource_name.trim_suffix(".tres")
			resource_dict[resource_to_load.scene_name] = resource_to_load
			ConsoleLog.DEBUG("Loaded "
				+ enum_to_string_scene_type(scene_type)
				+ " resource ("
				+ str(resource_name)
				+ ") into dictionary"
			)

	return resource_dict


func _instantiate_scene_for_name(scene_name : String) -> void:
	if not _check_resource_exists(scene_name):
		return

	var resource = scenedata_dictionary_all.get(scene_name)
	resource.instantiated_node = resource.scene_file.instantiate()











func load_all_resources() -> void:
	scenedata_dictionary_all.merge(_load_resources_from_path(RESOURCES_PATH_MENUS))
	scenedata_dictionary_all.merge(_load_resources_from_path(RESOURCES_PATH_HUDS))
	scenedata_dictionary_all.merge(_load_resources_from_path(RESOURCES_PATH_NPC_OVERLAYS))
	scenedata_dictionary_all.merge(_load_resources_from_path(RESOURCES_PATH_LEVELS))
	scenedata_dictionary_all.merge(_load_resources_from_path(RESOURCES_PATH_COMBATS))

	is_initialized = true


func instantiate_all_scenes() -> void:
	if not _check_initialization():
		return

	for resource in scenedata_dictionary_all.values():
		_instantiate_scene_for_name(resource.scene_name)












func is_scene_aviable(scene_name : String) -> bool:
	if not _check_initialization():
		return false

	if not _check_resource_exists(scene_name):
		return false

	return true


func is_scene_type_active(scene_type : SCENE_TYPE) -> bool:
	if scene_types_current_active[scene_type] == null:
		ConsoleLog.WARNING("No active scene of type: " + enum_to_string_scene_type(scene_type))
		return false
	else:
		ConsoleLog.DEBUG("Active scene of type: " + enum_to_string_scene_type(scene_type) + " is: " + scene_types_current_active[scene_type].scene_name)
		return true


func is_scene_loaded(scene_name : String) -> bool:
	var resource = scenedata_dictionary_all.get(scene_name)

	if resource.node_is_loaded:
		ConsoleLog.DEBUG("Scene is already loaded: " + scene_name)
		return true
	else:
		ConsoleLog.WARNING("Scene is not loaded: " + scene_name)
		return false


func is_scene_active(scene_name : String) -> bool:
	var resource = scenedata_dictionary_all.get(scene_name)

	if resource.node_is_active:
		ConsoleLog.DEBUG("Scene is already active: " + scene_name)
		return true
	else:
		ConsoleLog.WARNING("Scene is not active: " + scene_name)
		return false














func set_scenedata_activation_by_name(scene_name : String, activate : bool) -> void:
	var scene : SceneData = get_scenedata_by_name(scene_name)
	scene.node_is_active = activate
	if activate:
		scene_types_current_active[scene.is_scene_type] = scene
	else:
		scene_types_current_active[scene.is_scene_type] = null


func set_scenedata_activation_by_type(scene_type : SCENE_TYPE, activate : bool) -> void:
	if not _validate_scene_type(scene_type):
		return
	var scene : SceneData = get_scenedata_by_type(scene_type)
	scene.node_is_active = activate
	if activate:
		scene_types_current_active[scene_type] = scene
	else:
		scene_types_current_active[scene_type] = null








func set_scenedata_paused_by_name(scene_name : String, is_paused : bool) -> void:
	var scene : SceneData = get_scenedata_by_name(scene_name)
	scene.node_is_paused = is_paused


func set_scenedata_paused_by_type(scene_type : SCENE_TYPE, is_paused : bool) -> void:
	if not _validate_scene_type(scene_type):
		return
	var scene : SceneData = get_scenedata_by_type(scene_type)
	scene.node_is_paused = is_paused


func set_scenedata_hidden_by_name(scene_name : String, is_hidden : bool) -> void:
	var scene : SceneData = get_scenedata_by_name(scene_name)
	scene.node_is_hidden = is_hidden


func set_scenedata_hidden_by_type(scene_type : SCENE_TYPE, is_hidden : bool) -> void:
	if not _validate_scene_type(scene_type):
		return
	var scene : SceneData = get_scenedata_by_type(scene_type)
	scene.node_is_hidden = is_hidden




















func get_active_scenedata_node_by_name(scene_name : String) -> Node:
	return get_active_scenedata_by_name(scene_name).instantiated_node


func get_active_scenedata_node_by_type(scene_type : SCENE_TYPE) -> Node:
	return get_active_scenedata_by_type(scene_type).instantiated_node


func get_active_scenedata_by_name(scene_name : String) -> SceneData:
	var scene : SceneData = get_scenedata_by_name(scene_name)

	if not _validate_scene_type(scene.is_scene_type):
		return null

	return scene_types_current_active.get(scene.is_scene_type)


func get_active_scenedata_by_type(scene_type : SCENE_TYPE) -> SceneData:
	if not _validate_scene_type(scene_type):
		return null

	return scene_types_current_active.get(scene_type)










func get_scenedata_instantiated_node_by_name(scene_name : String) -> Node:
	return scenedata_dictionary_all.get(scene_name).instantiated_node


func get_scenedata_by_name(scene_name : String) -> SceneData:
	return scenedata_dictionary_all.get(scene_name)


func get_scenedata_by_type(scene_type : SCENE_TYPE) -> SceneData:
	if not _validate_scene_type(scene_type):
		return null

	return scenedata_dictionary_all.get(scene_type)
