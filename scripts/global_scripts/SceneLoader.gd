extends Node

const RESOURCES_PATH_LEVELS : String = "res://resources/levels/"
const RESOURCES_PATH_COMBATS : String = "res://resources/combats/"
const RESOURCES_PATH_HUDS : String = "res://resources/uis/huds/"
const RESOURCES_PATH_MENUS : String = "res://resources/uis/menus/"

enum SCENE_TYPE {
	NONE,
	MENU,
	HUD,
	LEVEL,
	COMBAT,
}

enum SCENE_PROCESS_TYPE {
	NONE,
	LOAD,
	UNLOAD,
	ACTIVATE,
	DEACTIVATE,
	PAUSE,
	RESUME,
}

enum MENU_TYPE {
	NONE,
	MAIN_MENU,
	PAUSE_MENU,
	SETTINGS_MENU,
	LOAD_GAME_MENU,
	SAVE_GAME_MENU,
	NEW_GAME_MENU,
	CAMPAIGN_MENU,
	GAME_OVER_MENU,
	VICTORY_MENU,
	INVENTORY_MENU,
	CHARACTER_STATS_MENU,
	SKILL_LEVELING_MENU,
}

enum HUD_TYPE {
	NONE,
	LEVEL_HUD,
	COMBAT_HUD,
	NPC_INTERACTION_HUD,
}

enum COMBAT_TYPE {
	NONE,
	TUTORIAL_FIGHT_COMBAT,
	RANDOM_ENCOUNTER_COMBAT,
	MISSION_ENCOUNTER_COMBAT,
	BOSS_FIGHT_COMBAT,
	FINAL_BOSS_FIGHT_COMBAT,
}

enum LEVEL_TYPE {
	NONE,
	LEVEL,
}

# Hier werden die call functions entsprechend der SCENE_TYPE und SUB_TYPE gespeichert,
# die beim aktivieren der jeweiligen scene aufgerufen werden sollen
# Die funktionen sagen, was mit den anderen aktuellen nodes passiert, wenn die jeweilige scene aktiviert bzw. deaktiviert wird:
# also zbsp.: wenn main menu aktiviert wird, wird die _process_main_menu_scene() funktion geladen und
# verwaltet die anderen current aktiven scenen
var lookup_table_scene_types_sub_types_process_current_nodes : Dictionary[SCENE_TYPE, Dictionary] = {
	SCENE_TYPE.MENU : {
		MENU_TYPE.MAIN_MENU : _process_main_menu_scene,
		MENU_TYPE.PAUSE_MENU : _process_pause_menu_scene,
		MENU_TYPE.SETTINGS_MENU : _process_settings_menu_scene,
		MENU_TYPE.LOAD_GAME_MENU : _process_load_game_menu_scene,
		MENU_TYPE.SAVE_GAME_MENU : _process_save_game_menu_scene,
		MENU_TYPE.NEW_GAME_MENU : _process_new_game_menu_scene,
		MENU_TYPE.CAMPAIGN_MENU : _process_campaign_menu_scene,
		MENU_TYPE.GAME_OVER_MENU : _process_game_over_menu_scene,
		MENU_TYPE.VICTORY_MENU : _process_victory_menu_scene,
		MENU_TYPE.INVENTORY_MENU : _process_inventory_menu_scene,
		MENU_TYPE.CHARACTER_STATS_MENU : _process_character_stats_menu_scene,
		MENU_TYPE.SKILL_LEVELING_MENU : _process_skill_leveling_menu_scene,
	},
	SCENE_TYPE.HUD : {
		HUD_TYPE.LEVEL_HUD : _process_level_hud_scene,
		HUD_TYPE.COMBAT_HUD : _process_combat_hud_scene,
		HUD_TYPE.NPC_INTERACTION_HUD : _process_npc_interaction_hud_scene,
	},
	SCENE_TYPE.LEVEL : {
		LEVEL_TYPE.LEVEL : _process_level_scene,
	},
	SCENE_TYPE.COMBAT : {
		COMBAT_TYPE.TUTORIAL_FIGHT_COMBAT : _process_tutorial_combat_fight_scene,
		COMBAT_TYPE.RANDOM_ENCOUNTER_COMBAT : _process_random_encounter_combat_fight_scene,
		COMBAT_TYPE.MISSION_ENCOUNTER_COMBAT : _process_mission_encounter_combat_fight_scene,
		COMBAT_TYPE.BOSS_FIGHT_COMBAT : _process_boss_fight_combat_scene,
		COMBAT_TYPE.FINAL_BOSS_FIGHT_COMBAT : _process_final_boss_fight_combat_scene,
	}
}

# Hier werden die Signale entsprechend der SCENE_TYPE und SUB_TYPE gespeichert,
# die beim laden der jeweiligen scene aufgerufen werden sollen
var lookup_table_scene_types_sub_types_emit_loaded_signal : Dictionary[SCENE_TYPE, Dictionary] = {
	SCENE_TYPE.MENU : {
		MENU_TYPE.MAIN_MENU : EventBus.main_menu_has_loaded,
		MENU_TYPE.PAUSE_MENU : EventBus.pause_menu_has_loaded,
		MENU_TYPE.SETTINGS_MENU : EventBus.settings_menu_has_loaded,
		MENU_TYPE.LOAD_GAME_MENU : EventBus.load_game_menu_has_loaded,
		MENU_TYPE.SAVE_GAME_MENU : EventBus.save_game_menu_has_loaded,
		MENU_TYPE.NEW_GAME_MENU : EventBus.new_game_menu_has_loaded,
		MENU_TYPE.CAMPAIGN_MENU : EventBus.campaign_menu_has_loaded,
		MENU_TYPE.GAME_OVER_MENU : EventBus.game_over_menu_has_loaded,
		MENU_TYPE.VICTORY_MENU : EventBus.victory_menu_has_loaded,
		MENU_TYPE.INVENTORY_MENU : EventBus.inventory_menu_has_loaded,
		MENU_TYPE.CHARACTER_STATS_MENU : EventBus.character_stats_menu_has_loaded,
		MENU_TYPE.SKILL_LEVELING_MENU : EventBus.skill_leveling_menu_has_loaded,
	},
	SCENE_TYPE.HUD : {
		HUD_TYPE.LEVEL_HUD : EventBus.level_hud_has_loaded,
		HUD_TYPE.COMBAT_HUD : EventBus.combat_hud_has_loaded,
		HUD_TYPE.NPC_INTERACTION_HUD : EventBus.npc_interaction_hud_has_loaded,
	},
	SCENE_TYPE.LEVEL : {
		LEVEL_TYPE.LEVEL : EventBus.level_has_loaded,
	},
	SCENE_TYPE.COMBAT : {
		COMBAT_TYPE.TUTORIAL_FIGHT_COMBAT : EventBus.tutorial_fight_combat_has_loaded,
		COMBAT_TYPE.RANDOM_ENCOUNTER_COMBAT : EventBus.random_encounter_combat_has_loaded,
		COMBAT_TYPE.MISSION_ENCOUNTER_COMBAT : EventBus.mission_encounter_combat_has_loaded,
		COMBAT_TYPE.BOSS_FIGHT_COMBAT : EventBus.boss_fight_combat_has_loaded,
		COMBAT_TYPE.FINAL_BOSS_FIGHT_COMBAT : EventBus.final_boss_fight_combat_has_loaded,
	}
}

# Hier werden die Signale entsprechend der SCENE_TYPE und SUB_TYPE gespeichert,
# die beim unloaden der jeweiligen scene aufgerufen werden sollen
var lookup_table_scene_types_sub_types_emit_unloaded_signal : Dictionary[SCENE_TYPE, Dictionary] = {
	SCENE_TYPE.MENU : {
		MENU_TYPE.MAIN_MENU : EventBus.main_menu_has_unloaded,
		MENU_TYPE.PAUSE_MENU : EventBus.pause_menu_has_unloaded,
		MENU_TYPE.SETTINGS_MENU : EventBus.settings_menu_has_unloaded,
		MENU_TYPE.LOAD_GAME_MENU : EventBus.load_game_menu_has_unloaded,
		MENU_TYPE.SAVE_GAME_MENU : EventBus.save_game_menu_has_unloaded,
		MENU_TYPE.NEW_GAME_MENU : EventBus.new_game_menu_has_unloaded,
		MENU_TYPE.CAMPAIGN_MENU : EventBus.campaign_menu_has_unloaded,
		MENU_TYPE.GAME_OVER_MENU : EventBus.game_over_menu_has_unloaded,
		MENU_TYPE.VICTORY_MENU : EventBus.victory_menu_has_unloaded,
		MENU_TYPE.INVENTORY_MENU : EventBus.inventory_menu_has_unloaded,
		MENU_TYPE.CHARACTER_STATS_MENU : EventBus.character_stats_menu_has_unloaded,
		MENU_TYPE.SKILL_LEVELING_MENU : EventBus.skill_leveling_menu_has_unloaded,
	},
	SCENE_TYPE.HUD : {
		HUD_TYPE.LEVEL_HUD : EventBus.level_hud_has_unloaded,
		HUD_TYPE.COMBAT_HUD : EventBus.combat_hud_has_unloaded,
		HUD_TYPE.NPC_INTERACTION_HUD : EventBus.npc_interaction_hud_has_unloaded,
	},
	SCENE_TYPE.LEVEL : {
		LEVEL_TYPE.LEVEL : EventBus.level_has_unloaded,
	},
	SCENE_TYPE.COMBAT : {
		COMBAT_TYPE.TUTORIAL_FIGHT_COMBAT : EventBus.tutorial_fight_combat_has_unloaded,
		COMBAT_TYPE.RANDOM_ENCOUNTER_COMBAT : EventBus.random_encounter_combat_has_unloaded,
		COMBAT_TYPE.MISSION_ENCOUNTER_COMBAT : EventBus.mission_encounter_combat_has_unloaded,
		COMBAT_TYPE.BOSS_FIGHT_COMBAT : EventBus.boss_fight_combat_has_unloaded,
		COMBAT_TYPE.FINAL_BOSS_FIGHT_COMBAT : EventBus.final_boss_fight_combat_has_unloaded,
	}
}

# Hier werden die Signale entsprechend der SCENE_TYPE und SUB_TYPE gespeichert,
# die beim aktivieren der jeweiligen scene aufgerufen werden sollen
var lookup_table_scene_types_sub_types_emit_activated_signal : Dictionary[SCENE_TYPE, Dictionary] = {
	SCENE_TYPE.MENU : {
		MENU_TYPE.MAIN_MENU : EventBus.main_menu_has_activated,
		MENU_TYPE.PAUSE_MENU : EventBus.pause_menu_has_activated,
		MENU_TYPE.SETTINGS_MENU : EventBus.settings_menu_has_activated,
		MENU_TYPE.LOAD_GAME_MENU : EventBus.load_game_menu_has_activated,
		MENU_TYPE.SAVE_GAME_MENU : EventBus.save_game_menu_has_activated,
		MENU_TYPE.NEW_GAME_MENU : EventBus.new_game_menu_has_activated,
		MENU_TYPE.CAMPAIGN_MENU : EventBus.campaign_menu_has_activated,
		MENU_TYPE.GAME_OVER_MENU : EventBus.game_over_menu_has_activated,
		MENU_TYPE.VICTORY_MENU : EventBus.victory_menu_has_activated,
		MENU_TYPE.INVENTORY_MENU : EventBus.inventory_menu_has_activated,
		MENU_TYPE.CHARACTER_STATS_MENU : EventBus.character_stats_menu_has_activated,
		MENU_TYPE.SKILL_LEVELING_MENU : EventBus.skill_leveling_menu_has_activated,
	},
	SCENE_TYPE.HUD : {
		HUD_TYPE.LEVEL_HUD : EventBus.level_hud_has_activated,
		HUD_TYPE.COMBAT_HUD : EventBus.combat_hud_has_activated,
		HUD_TYPE.NPC_INTERACTION_HUD : EventBus.npc_interaction_hud_has_activated,
	},
	SCENE_TYPE.LEVEL : {
		LEVEL_TYPE.LEVEL : EventBus.level_has_activated,
	},
	SCENE_TYPE.COMBAT : {
		COMBAT_TYPE.TUTORIAL_FIGHT_COMBAT : EventBus.tutorial_fight_combat_has_activated,
		COMBAT_TYPE.RANDOM_ENCOUNTER_COMBAT : EventBus.random_encounter_combat_has_activated,
		COMBAT_TYPE.MISSION_ENCOUNTER_COMBAT : EventBus.mission_encounter_combat_has_activated,
		COMBAT_TYPE.BOSS_FIGHT_COMBAT : EventBus.boss_fight_combat_has_activated,
		COMBAT_TYPE.FINAL_BOSS_FIGHT_COMBAT : EventBus.final_boss_fight_combat_has_activated,
	}
}

# Hier werden die Signale entsprechend der SCENE_TYPE und SUB_TYPE gespeichert,
# die beim deaktivieren der jeweiligen scene aufgerufen werden sollen
var lookup_table_scene_types_sub_types_emit_deactivated_signal : Dictionary[SCENE_TYPE, Dictionary] = {
	SCENE_TYPE.MENU : {
		MENU_TYPE.MAIN_MENU : EventBus.main_menu_has_deactivated,
		MENU_TYPE.PAUSE_MENU : EventBus.pause_menu_has_deactivated,
		MENU_TYPE.SETTINGS_MENU : EventBus.settings_menu_has_deactivated,
		MENU_TYPE.LOAD_GAME_MENU : EventBus.load_game_menu_has_deactivated,
		MENU_TYPE.SAVE_GAME_MENU : EventBus.save_game_menu_has_deactivated,
		MENU_TYPE.NEW_GAME_MENU : EventBus.new_game_menu_has_deactivated,
		MENU_TYPE.CAMPAIGN_MENU : EventBus.campaign_menu_has_deactivated,
		MENU_TYPE.GAME_OVER_MENU : EventBus.game_over_menu_has_deactivated,
		MENU_TYPE.VICTORY_MENU : EventBus.victory_menu_has_deactivated,
		MENU_TYPE.INVENTORY_MENU : EventBus.inventory_menu_has_deactivated,
		MENU_TYPE.CHARACTER_STATS_MENU : EventBus.character_stats_menu_has_deactivated,
		MENU_TYPE.SKILL_LEVELING_MENU : EventBus.skill_leveling_menu_has_deactivated,
	},
	SCENE_TYPE.HUD : {
		HUD_TYPE.LEVEL_HUD : EventBus.level_hud_has_deactivated,
		HUD_TYPE.COMBAT_HUD : EventBus.combat_hud_has_deactivated,
		HUD_TYPE.NPC_INTERACTION_HUD : EventBus.npc_interaction_hud_has_deactivated,
	},
	SCENE_TYPE.LEVEL : {
		LEVEL_TYPE.LEVEL : EventBus.level_has_deactivated,
	},
	SCENE_TYPE.COMBAT : {
		COMBAT_TYPE.TUTORIAL_FIGHT_COMBAT : EventBus.tutorial_fight_combat_has_deactivated,
		COMBAT_TYPE.RANDOM_ENCOUNTER_COMBAT : EventBus.random_encounter_combat_has_deactivated,
		COMBAT_TYPE.MISSION_ENCOUNTER_COMBAT : EventBus.mission_encounter_combat_has_deactivated,
		COMBAT_TYPE.BOSS_FIGHT_COMBAT : EventBus.boss_fight_combat_has_deactivated,
		COMBAT_TYPE.FINAL_BOSS_FIGHT_COMBAT : EventBus.final_boss_fight_combat_has_deactivated,
	}
}


var resources_all_dictionary : Dictionary[String, Resource]
var current_loaded_scene_nodes_dictionary : Dictionary[Resource, Node]
# var current_active_scene_nodes_dictionary : Dictionary[Resource, Node]

## Dictionary, dass die SCENE_TYPEs den entsprechenden Nodes zuordnet, an die die Szenen angehängt werden sollen
## READ ONLY: Die Nodes werden von Main.gd übergeben und dürfen nicht verändert werden
var scene_types_main_nodes : Dictionary[SCENE_TYPE, Node] = {
	SCENE_TYPE.MENU : null,
	SCENE_TYPE.HUD : null,
	SCENE_TYPE.LEVEL : null,
	SCENE_TYPE.COMBAT : null
}

## Dictionary, dass die gerade aktiven Szenen pro SCENE_TYPE speichert,
## um beim aktivieren einer neuen scene entsprechend die nodes im tree zu verwalten
## (z.B. beim Wechsel von Level zu Combat, dass der Level node deaktiviert wird)
## deaktiviert heißt nicht gelöscht, sondern nur aus dem tree entfernt; aber wird gebraucht zum tracken
var current_active_scene_resources_scene_type_dictionary : Dictionary[SCENE_TYPE, Resource] = {
	SCENE_TYPE.MENU : null,
	SCENE_TYPE.HUD : null,
	SCENE_TYPE.LEVEL : null,
	SCENE_TYPE.COMBAT : null
}

var is_initialized : bool = false





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_all_resources_for_path(RESOURCES_PATH_MENUS)
	_load_all_resources_for_path(RESOURCES_PATH_HUDS)
	_load_all_resources_for_path(RESOURCES_PATH_LEVELS)
	_load_all_resources_for_path(RESOURCES_PATH_COMBATS)

	_load_all_nodes_for_scene_type(SCENE_TYPE.MENU)
	_load_all_nodes_for_scene_type(SCENE_TYPE.HUD)


















func _check_initialization() -> bool:
	if not is_initialized:
		ConsoleLog.ERROR(
			"SceneLoader has not been initialized. "
			+ "Please call init_vars() from Main.gd before using SceneLoader."
		)
	return is_initialized


func _enum_to_string_scene_type(scene_type : SCENE_TYPE) -> String:
	var key_name = SCENE_TYPE.find_key(scene_type)
	if key_name != null:
		return key_name
	return "UNKNOWN"


func _string_to_enum_scene_type(scene_type_str : String) -> SCENE_TYPE:
	return SCENE_TYPE.get(scene_type_str, SCENE_TYPE.NONE)


func _enum_to_string_scene_process_type(scene_process_type : SCENE_PROCESS_TYPE) -> String:
	var key_name = SCENE_PROCESS_TYPE.find_key(scene_process_type)
	if key_name != null:
		return key_name
	return "UNKNOWN"


func _string_to_enum_scene_process_type(scene_process_type_str : String) -> SCENE_PROCESS_TYPE:
	return SCENE_PROCESS_TYPE.get(scene_process_type_str, SCENE_PROCESS_TYPE.NONE)











func _load_all_resources_for_path(resource_path : String) -> void:
	for resource_name in DirAccess.open(resource_path).get_files():
		if resource_name.ends_with(".tres"):
			var resource_to_load = load(resource_path + resource_name)
			var scene_type = resource_to_load.is_scene_type
			resource_to_load.name = resource_name.trim_suffix(".tres")
			resources_all_dictionary[resource_to_load.name] = resource_to_load
			ConsoleLog.DEBUG("Loaded "
				+ _enum_to_string_scene_type(scene_type)
				+ " resource ("
				+ str(resource_name)
				+ ") into dictionary"
			)


func _load_all_nodes_for_scene_type(scene_type : SCENE_TYPE) -> void:
	for resource in resources_all_dictionary.values():
		if resource.is_scene_type == scene_type:
			_load_node(self, resource)













## Initalisierung der Variablen, die von Main.gd übergeben werden;
## Zu übergebene Nodes befinden sich im Main Node
func init_vars(called_by : Object, _menu_canvas_layer : CanvasLayer, _hud_canvas_layer : CanvasLayer, _combat_scenes : Node, _level_scenes : Node) -> void:
	if called_by.get_script().get_global_name() != "Main":
		ConsoleLog.ERROR(
			"SceneLoader.init_vars() can only be called from Main.gd"
		)
		return
	scene_types_main_nodes[SCENE_TYPE.MENU] = _menu_canvas_layer
	scene_types_main_nodes[SCENE_TYPE.HUD] = _hud_canvas_layer
	scene_types_main_nodes[SCENE_TYPE.COMBAT] = _combat_scenes
	scene_types_main_nodes[SCENE_TYPE.LEVEL] = _level_scenes

	is_initialized = true



















func _check_scene_node_active(scene_resource_to_check : Resource) -> bool:
	var _check_resource : Resource = current_active_scene_resources_scene_type_dictionary[scene_resource_to_check.is_scene_type]
	if _check_resource == null or _check_resource != scene_resource_to_check:
		ConsoleLog.WARNING(
			"Scene node not active for: "
			+ scene_resource_to_check.name
		)
		return false

	ConsoleLog.DEBUG(
		"Scene node already active for: "
		+ scene_resource_to_check.name
	)
	return true


func _check_scene_node_loaded(scene_resource_to_check : Resource) -> bool:
	if current_loaded_scene_nodes_dictionary.has(scene_resource_to_check):
		ConsoleLog.DEBUG(
			"Scene node already loaded for: "
			+ scene_resource_to_check.name
		)
		return true

	ConsoleLog.WARNING(
		"Scene node not loaded for: "
		+ scene_resource_to_check.name
	)
	return false


func _check_resource_exists(scene_name_to_check : String) -> bool:
	if resources_all_dictionary.has(scene_name_to_check):
		ConsoleLog.DEBUG(
			"Resource found for: "
			+ scene_name_to_check
		)
		return true

	ConsoleLog.WARNING(
		"Resource not found for: "
		+ scene_name_to_check
	)

	return false















# TODO!!!!: ERROR FIXING
func _process_main_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.LEVEL or effected_resource.is_scene_type == SCENE_TYPE.COMBAT:
			_deactivate_node(called_by, effected_resource)
			_unload_node(called_by, effected_resource)
		elif effected_resource.is_scene_type == SCENE_TYPE.HUD or effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
		TimerGlobal.stop_timer()


func _process_pause_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
		else:
			_pause_node(effected_resource)
		TimerGlobal.pause_timer()
	else:
		if effected_resource.is_scene_type != SCENE_TYPE.MENU:
			_unpause_node(effected_resource)
			TimerGlobal.unpause_timer()


func _process_settings_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_load_game_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_save_game_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_new_game_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_campaign_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_game_over_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		pass
	else:
		pass


func _process_victory_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		pass
	else:
		pass


func _process_inventory_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
		else:
			_pause_node(effected_resource)
		TimerGlobal.pause_timer()
	else:
		if effected_resource.is_scene_type != SCENE_TYPE.MENU:
			_unpause_node(effected_resource)
		TimerGlobal.unpause_timer()


func _process_character_stats_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_skill_leveling_menu_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_level_hud_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		pass
	else:
		pass


func _process_combat_hud_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		pass
	else:
		pass


func _process_npc_interaction_hud_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		pass
	else:
		pass


func _process_level_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		if effected_resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(called_by, effected_resource)
		if effected_resource.is_scene_type == SCENE_TYPE.HUD:
			_deactivate_node(called_by, effected_resource)
		if effected_resource.is_scene_type == SCENE_TYPE.LEVEL or effected_resource.is_scene_type == SCENE_TYPE.COMBAT:
			_deactivate_node(called_by, effected_resource)
			_unload_node(called_by, effected_resource)
	else:
		pass


func _process_tutorial_combat_fight_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_random_encounter_combat_fight_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_mission_encounter_combat_fight_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_boss_fight_combat_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		_deactivate_node(called_by, effected_resource)
	else:
		pass


func _process_final_boss_fight_combat_scene(called_by : Node, effected_resource : Resource, is_activation : bool) -> void:
	if is_activation:
		_deactivate_node(called_by, effected_resource)
	else:
		pass














# TODO!!!!: NODE ACTIVATION UND DEACTIVATION ABHÄNGIG VON SCENE_TYPE UND SUB_TYPE VERWALTEN
# ABER RICHTIG UND FINAL DIESMAL



func _process_node_depending_on_type_and_subtype(called_by : Node, resource_to_process : Resource, is_activation : bool) -> void:
	var callable_function : Callable
	var scene_type_to_process : SCENE_TYPE = resource_to_process.is_scene_type
	var scene_subtype_to_process : int = resource_to_process.is_scene_subtype
	var scene_subtype_dictionary : Dictionary = lookup_table_scene_types_sub_types_process_current_nodes.get(scene_type_to_process)

	if scene_subtype_dictionary == null:
		ConsoleLog.WARNING(
			"No callable functions found for scene type: "
			+ _enum_to_string_scene_type(scene_type_to_process)
		)
		return

	callable_function = scene_subtype_dictionary.get(scene_subtype_to_process)

	if callable_function.is_valid():
		for effected_resource in current_active_scene_resources_scene_type_dictionary.values():
			if effected_resource == null:
				continue
			callable_function.call(called_by, effected_resource, is_activation)
	else:
		ConsoleLog.ERROR(
			"Callable function is not valid or not found for scene subtype: "
			+ str(scene_subtype_to_process)
			+ " of scene type: "
			+ _enum_to_string_scene_type(scene_type_to_process)
		)

	if is_activation:
		current_active_scene_resources_scene_type_dictionary[scene_type_to_process] = resource_to_process
	else:
		current_active_scene_resources_scene_type_dictionary[scene_type_to_process] = null

	ConsoleLog.DEBUG(
		"Processed node for scene type: "
		+ _enum_to_string_scene_type(scene_type_to_process)
		+ " and scene subtype: "
		+ str(scene_subtype_to_process)
		+ " with activation status: "
		+ str(is_activation)
	)























func _emit_signal(called_by : Node, resource_to_emit : Resource, node_to_emit : Node, scene_process : SCENE_PROCESS_TYPE = SCENE_PROCESS_TYPE.NONE) -> void:
	var signal_to_emit : Signal

	match scene_process:
		SCENE_PROCESS_TYPE.LOAD:
			signal_to_emit = lookup_table_scene_types_sub_types_emit_loaded_signal[resource_to_emit.is_scene_type][resource_to_emit.is_scene_subtype]
		SCENE_PROCESS_TYPE.UNLOAD:
			signal_to_emit = lookup_table_scene_types_sub_types_emit_unloaded_signal[resource_to_emit.is_scene_type][resource_to_emit.is_scene_subtype]
		SCENE_PROCESS_TYPE.ACTIVATE:
			signal_to_emit = lookup_table_scene_types_sub_types_emit_activated_signal[resource_to_emit.is_scene_type][resource_to_emit.is_scene_subtype]
		SCENE_PROCESS_TYPE.DEACTIVATE:
			signal_to_emit = lookup_table_scene_types_sub_types_emit_deactivated_signal[resource_to_emit.is_scene_type][resource_to_emit.is_scene_subtype]
		_:
			ConsoleLog.WARNING(
				"Invalid scene process type for emitting signal: "
				+ _enum_to_string_scene_process_type(scene_process)
			)

	if signal_to_emit != null:
		# signal_to_emit.emit(node_to_emit, EventBus.generate_signal_key())
		EventBus.emit_signal_with_log(signal_to_emit, [called_by, node_to_emit])
	else:
		ConsoleLog.WARNING(
			"No "
			+ _enum_to_string_scene_process_type(scene_process)
			+ " signal found to emit for scene type: "
			+ _enum_to_string_scene_type(resource_to_emit.is_scene_type)
			+ " and scene subtype: "
			+ str(resource_to_emit.is_scene_subtype)
		)






















func _load_node(called_by : Node, resource_to_load : Resource) -> Node:
	if _check_scene_node_loaded(resource_to_load):
		return current_loaded_scene_nodes_dictionary[resource_to_load]

	var scene_node_to_load : Node = resource_to_load.scene_file.instantiate()
	current_loaded_scene_nodes_dictionary[resource_to_load] = scene_node_to_load

	_emit_signal(called_by, resource_to_load, scene_node_to_load, SCENE_PROCESS_TYPE.LOAD)

	ConsoleLog.MESSAGE(
		"Loaded scene node: "
		+ resource_to_load.name
	)

	return scene_node_to_load


func _unload_node(called_by : Node, resource_to_unload : Resource) -> void:
	if not _check_scene_node_loaded(resource_to_unload):
		return

	var node_to_unload : Node = current_loaded_scene_nodes_dictionary[resource_to_unload]

	current_loaded_scene_nodes_dictionary.erase(resource_to_unload)

	node_to_unload.queue_free()
	_emit_signal(called_by, resource_to_unload, node_to_unload, SCENE_PROCESS_TYPE.UNLOAD)

	ConsoleLog.MESSAGE(
		"Unloaded scene node: "
		+ resource_to_unload.name
	)


func _activate_node(called_by : Node, resource_to_activate : Resource) -> Node:
	if _check_scene_node_active(resource_to_activate):
		return current_loaded_scene_nodes_dictionary[resource_to_activate]

	var scene_node_to_activate : Node = current_loaded_scene_nodes_dictionary[resource_to_activate]

	_process_node_depending_on_type_and_subtype(called_by, resource_to_activate, true)

	if resource_to_activate.is_scene_type == SCENE_TYPE.LEVEL:
		activate_scene(called_by, "level_hud")
	elif resource_to_activate.is_scene_type == SCENE_TYPE.COMBAT:
		activate_scene(called_by, "combat_hud")

	scene_types_main_nodes[resource_to_activate.is_scene_type].add_child(scene_node_to_activate)

	_emit_signal(called_by, resource_to_activate, scene_node_to_activate, SCENE_PROCESS_TYPE.ACTIVATE)

	ConsoleLog.MESSAGE(
		"Activated scene node: "
		+ resource_to_activate.name
	)

	return scene_node_to_activate


func _deactivate_node(called_by : Node, resource_to_deactivate : Resource) -> void:
	if not _check_scene_node_active(resource_to_deactivate):
		return

	var main_node_scene_type : Node = scene_types_main_nodes[resource_to_deactivate.is_scene_type]
	var scene_node_to_deactivate : Node = current_loaded_scene_nodes_dictionary[resource_to_deactivate]

	_process_node_depending_on_type_and_subtype(called_by, resource_to_deactivate, false)

	if resource_to_deactivate.is_scene_type == SCENE_TYPE.LEVEL:
		deactivate_scene(called_by, "level_hud")
	elif resource_to_deactivate.is_scene_type == SCENE_TYPE.COMBAT:
		deactivate_scene(called_by, "combat_hud")

	if main_node_scene_type.has_node(scene_node_to_deactivate.get_path()):
		main_node_scene_type.remove_child(scene_node_to_deactivate)
		ConsoleLog.DEBUG(
			"Removed scene node from main node: "
			+ resource_to_deactivate.name
		)
	else:
		ConsoleLog.WARNING(
			"Scene node not found in main node for deactivation: "
			+ resource_to_deactivate.name
		)

	_emit_signal(called_by, resource_to_deactivate, scene_node_to_deactivate, SCENE_PROCESS_TYPE.DEACTIVATE)

	ConsoleLog.MESSAGE(
		"Deactivated scene node: "
		+ resource_to_deactivate.name
	)





# git commit -m "refined scene_loader; refined ConsoleLog (easier to log things); extracted input for open inv and pause into global script; testing loading of levels and pausing them on opening inv or pause"



func _unpause_node(resource_to_unpause : Resource) -> void:
	if not _check_scene_node_active(resource_to_unpause):
		return

	current_loaded_scene_nodes_dictionary[resource_to_unpause].process_mode = Node.PROCESS_MODE_INHERIT

	ConsoleLog.MESSAGE(
			"Unpaused scene node: "
			+ resource_to_unpause.name
		)


func _pause_node(resource_to_pause : Resource) -> void:
	if not _check_scene_node_active(resource_to_pause):
		return

	current_loaded_scene_nodes_dictionary[resource_to_pause].process_mode = Node.PROCESS_MODE_DISABLED

	ConsoleLog.MESSAGE(
		"Paused scene node: "
		+ resource_to_pause.name
	)


func _show_node(resource_to_show : Resource) -> void:
	if not _check_scene_node_active(resource_to_show):
		return

	current_loaded_scene_nodes_dictionary[resource_to_show].show()
	current_loaded_scene_nodes_dictionary[resource_to_show].process_mode = Node.PROCESS_MODE_INHERIT

	ConsoleLog.MESSAGE(
		"Shown scene node: "
		+ resource_to_show.name
	)


func _hide_node(resource_to_hide : Resource) -> void:
	if not _check_scene_node_active(resource_to_hide):
		return

	current_loaded_scene_nodes_dictionary[resource_to_hide].hide()
	current_loaded_scene_nodes_dictionary[resource_to_hide].process_mode = Node.PROCESS_MODE_DISABLED

	ConsoleLog.MESSAGE(
		"Hidden scene node: "
		+ resource_to_hide.name
	)





# IDEE DAHINTER: Der SceneLoader verwaltet die geladenen und aktiven Szenen; man muss nur einmal load bzw. unload aufrufen
# und der SceneLoader kümmert sich um die Aktivierung/Deaktivierung der Szenen, die geladen werden müssen,
# und das Entladen der Szenen, die nicht mehr benötigt werden.
# Die namen der zu ladenen scenen entspricht den namen der resourcen für die jeweiligen scenen

# WICHTIG: Es handelt sich hier nur um die hauptscenen, also die scenen, die den kompletten bildschirm verändern:
# wie overlay hud für combat oder level, die menüs, die level und die combat scenen.
# Die einzelnen UI Elemente, die in den HUDs oder Menüs angezeigt werden, werden von den jeweiligen HUDs und Menüs verwaltet.
# Also ein wechsel von einem menü, ins andere menü, würde hier verwaltet werden,
# aber nicht von einem menü in ein untermenü, das wird von den jeweiligen menüs verwaltet.

# Aktivierung: Geladene Scene (Instantiated Node) wird an den entsprechenden Main Node angehängt und in current_active_scene_nodes_dictionary gespeichert
# Deaktivierung: Scene wird aus dem Main Node entfernt und aus current_active_scene_nodes_dictionary gelöscht
# Laden: Scene wird in current_loaded_scene_nodes_dictionary gespeichert, Instantiated Node wird erstellt
# Entladen: Scene wird deaktiviert und aus current_loaded_scene_nodes_dictionary gelöscht, Instantiated Node wird gelöscht (queue_free)



# lädt scene in speicher und aktiviert diese
func load_scene(called_by : Object, resource_name_to_load : String) -> Node:
	if not _check_initialization():
		return null

	if not _check_resource_exists(resource_name_to_load):
		return null

	return _load_node(called_by, resources_all_dictionary[resource_name_to_load])


# entlädt scene aus speicher und deaktiviert diese auch vorher, falls sie aktiv ist
func unload_scene(called_by : Object, resource_name_to_unload : String) -> void:
	if not _check_initialization():
		return

	if not _check_resource_exists(resource_name_to_unload):
		return

	_unload_node(called_by, resources_all_dictionary[resource_name_to_unload])


# aktiviert scene, die bereits geladen ist, in den tree
func activate_scene(called_by : Object, resource_name_to_activate : String) -> Node:
	if not _check_initialization():
		return null

	if not _check_resource_exists(resource_name_to_activate):
		return null

	return _activate_node(called_by, resources_all_dictionary[resource_name_to_activate])


# deaktiviert scene, die bereits geladen ist, aus dem tree
func deactivate_scene(called_by : Object, resource_name_to_deactivate : String) -> void:
	if not _check_initialization():
		return

	if not _check_resource_exists(resource_name_to_deactivate):
		return

	_deactivate_node(called_by, resources_all_dictionary[resource_name_to_deactivate])
