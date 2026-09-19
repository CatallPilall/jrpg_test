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
# die beim laden der jeweiligen scene aufgerufen werden sollen
var lookup_table_scene_types_sub_types_process_active_nodes : Dictionary[SCENE_TYPE, Dictionary] = {
	SCENE_TYPE.MENU : {
		MENU_TYPE.MAIN_MENU : _entered_main_menu_scene,
		MENU_TYPE.PAUSE_MENU : _entered_pause_menu_scene,
		MENU_TYPE.SETTINGS_MENU : _entered_settings_menu_scene,
		MENU_TYPE.LOAD_GAME_MENU : _entered_load_game_menu_scene,
		MENU_TYPE.SAVE_GAME_MENU : _entered_save_game_menu_scene,
		MENU_TYPE.NEW_GAME_MENU : _entered_new_game_menu_scene,
		MENU_TYPE.CAMPAIGN_MENU : _entered_campaign_menu_scene,
		MENU_TYPE.GAME_OVER_MENU : _entered_game_over_menu_scene,
		MENU_TYPE.VICTORY_MENU : _entered_victory_menu_scene,
		MENU_TYPE.INVENTORY_MENU : _entered_inventory_menu_scene,
		MENU_TYPE.CHARACTER_STATS_MENU : _entered_character_stats_menu_scene,
		MENU_TYPE.SKILL_LEVELING_MENU : _entered_skill_leveling_menu_scene,
	},
	SCENE_TYPE.HUD : {
		HUD_TYPE.LEVEL_HUD : _entered_level_hud_scene,
		HUD_TYPE.COMBAT_HUD : _entered_combat_hud_scene,
		HUD_TYPE.NPC_INTERACTION_HUD : _entered_npc_interaction_hud_scene,
	},
	SCENE_TYPE.LEVEL : {
		LEVEL_TYPE.LEVEL : _entered_level_scene,
	},
	SCENE_TYPE.COMBAT : {
		COMBAT_TYPE.TUTORIAL_FIGHT_COMBAT : _entered_tutorial_combat_fight_scene,
		COMBAT_TYPE.RANDOM_ENCOUNTER_COMBAT : _entered_random_encounter_combat_fight_scene,
		COMBAT_TYPE.MISSION_ENCOUNTER_COMBAT : _entered_mission_encounter_combat_fight_scene,
		COMBAT_TYPE.BOSS_FIGHT_COMBAT : _entered_boss_fight_combat_scene,
		COMBAT_TYPE.FINAL_BOSS_FIGHT_COMBAT : _entered_final_boss_fight_combat_scene,
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
# die beim ausladen der jeweiligen scene aufgerufen werden sollen
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


var resources_all_dictionary : Dictionary[String, Resource]
var current_loaded_scene_nodes_dictionary : Dictionary[Resource, Node]
var current_active_scene_nodes_dictionary : Dictionary[Resource, Node]

## Dictionary, dass die SCENE_TYPEs den entsprechenden Nodes zuordnet, an die die Szenen angehängt werden sollen
## READ ONLY: Die Nodes werden von Main.gd übergeben und dürfen nicht verändert werden
var scene_types_main_nodes : Dictionary[SCENE_TYPE, Node] = {
	SCENE_TYPE.MENU : null,
	SCENE_TYPE.HUD : null,
	SCENE_TYPE.LEVEL : null,
	SCENE_TYPE.COMBAT : null
}

## Dictionary, dass die zuletzt aktiven Szenen pro SCENE_TYPE speichert,
## um bei laden einer scene entsprechend die alten zu deaktivieren und ggf. zu entladen
var last_active_scene_resources_type_dictionary : Dictionary[SCENE_TYPE, Resource] = {
	SCENE_TYPE.MENU : null,
	SCENE_TYPE.HUD : null,
	SCENE_TYPE.LEVEL : null,
	SCENE_TYPE.COMBAT : null
}

var is_initialized : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_resources(RESOURCES_PATH_MENUS)
	_load_resources(RESOURCES_PATH_HUDS)
	_load_resources(RESOURCES_PATH_LEVELS)
	_load_resources(RESOURCES_PATH_COMBATS)

	_load_all_menu_nodes()
	_load_all_hud_nodes()


















func _check_initialization() -> bool:
	if not is_initialized:
		ConsoleLog.ERROR(
			self,
			"SceneLoader has not been initialized.
			Please call init_vars() from Main.gd before using SceneLoader."
		)
	return is_initialized


func _enum_to_string(scene_type: SCENE_TYPE) -> String:
	var key_name = SCENE_TYPE.find_key(scene_type)
	if key_name != null:
		return key_name
	return "UNKNOWN"


func _string_to_enum(scene_type_str : String) -> SCENE_TYPE:
	return SCENE_TYPE.get(scene_type_str, SCENE_TYPE.NONE)















func _load_resources(resource_path : String) -> void:
	for resource_name in DirAccess.open(resource_path).get_files():
		if resource_name.ends_with(".tres"):
			var resource_to_load = load(resource_path + resource_name)
			var scene_type = resource_to_load.is_scene_type
			resource_to_load.name = resource_name.trim_suffix(".tres")
			resources_all_dictionary[resource_to_load.name] = resource_to_load
			ConsoleLog.DEBUG(self, "Loaded " + _enum_to_string(scene_type) + " resource into dictionary: " + str(resource_name))


func _load_all_hud_nodes() -> void:
	for resource in resources_all_dictionary.values():
		if resource.is_scene_type == SCENE_TYPE.HUD:
			var scene_node = resource.scene_file.instantiate()
			current_loaded_scene_nodes_dictionary[resource] = scene_node
			ConsoleLog.DEBUG(self, "Loaded HUD scene node into dictionary current_loaded_scene_nodes_dictionary: " + resource.name)


func _load_all_menu_nodes() -> void:
	for resource in resources_all_dictionary.values():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			var scene_node = resource.scene_file.instantiate()
			current_loaded_scene_nodes_dictionary[resource] = scene_node
			ConsoleLog.DEBUG(self, "Loaded menu scene node into dictionary current_loaded_scene_nodes_dictionary: " + resource.name)


func _load_all_combat_nodes() -> void:
	for resource in resources_all_dictionary.values():
		if resource.is_scene_type == SCENE_TYPE.COMBAT:
			var scene_node = resource.scene_file.instantiate()
			current_loaded_scene_nodes_dictionary[resource] = scene_node
			ConsoleLog.DEBUG(self, "Loaded combat scene node into dictionary current_loaded_scene_nodes_dictionary: " + resource.name)


func _load_all_level_nodes() -> void:
	for resource in resources_all_dictionary.values():
		if resource.is_scene_type == SCENE_TYPE.LEVEL:
			var scene_node = resource.scene_file.instantiate()
			current_loaded_scene_nodes_dictionary[resource] = scene_node
			ConsoleLog.DEBUG(self, "Loaded level scene node into dictionary current_loaded_scene_nodes_dictionary: " + resource.name)














## Initalisierung der Variablen, die von Main.gd übergeben werden;
## Zu übergebene Nodes befinden sich im Main Node
func init_vars(_called_by : Object, _menu_canvas_layer : CanvasLayer, _hud_canvas_layer : CanvasLayer, _combat_scenes : Node, _level_scenes : Node) -> void:
	if _called_by.get_script().get_global_name() != "Main":
		ConsoleLog.ERROR(
			self,
			"SceneLoader.init_vars() can only be called from Main.gd"
		)
		return
	scene_types_main_nodes[SCENE_TYPE.MENU] = _menu_canvas_layer
	scene_types_main_nodes[SCENE_TYPE.HUD] = _hud_canvas_layer
	scene_types_main_nodes[SCENE_TYPE.COMBAT] = _combat_scenes
	scene_types_main_nodes[SCENE_TYPE.LEVEL] = _level_scenes

	is_initialized = true



















func _check_scene_node_active(scene_resource_to_load : Resource) -> Node:
	var scene_node : Node = current_active_scene_nodes_dictionary.get(scene_resource_to_load)

	if scene_node != null:
		ConsoleLog.DEBUG(
			self,
			"Scene node already active for: " + scene_resource_to_load.name
		)
	else:
		ConsoleLog.DEBUG(
			self,
			"Scene node not active for: " + scene_resource_to_load.name
		)

	return scene_node


func _check_scene_node_loaded(scene_resource_to_load : Resource) -> Node:
	var scene_node : Node = current_loaded_scene_nodes_dictionary.get(scene_resource_to_load)

	if scene_node != null:
		ConsoleLog.DEBUG(
			self,
			"Scene node already loaded for: " + scene_resource_to_load.name
		)
	else:
		ConsoleLog.DEBUG(
			self,
			"Scene node not loaded for: " + scene_resource_to_load.name
		)

	return scene_node


func _check_resource_exists(scene_name_to_load : String) -> Resource:
	var scene_resource : Resource = resources_all_dictionary.get(scene_name_to_load)

	if scene_resource != null:
		ConsoleLog.DEBUG(
			self,
			"Resource found for: " + scene_name_to_load
		)
	else:
		ConsoleLog.WARNING(
			self,
			"Resource not found for: " + scene_name_to_load
		)

	return scene_resource




















func _entered_main_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_loaded_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.LEVEL:
			_unload_node(resource, current_active_scene_nodes_dictionary[resource])
		elif resource.is_scene_type == SCENE_TYPE.COMBAT:
			_unload_node(resource, current_active_scene_nodes_dictionary[resource])

	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.HUD:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL] = null
	last_active_scene_resources_type_dictionary[SCENE_TYPE.COMBAT] = null
	last_active_scene_resources_type_dictionary[SCENE_TYPE.HUD] = null

	ConsoleLog.DEBUG(
		self,
		"Entered main menu scene"
	)


func _entered_pause_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		else:
			_pause_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null
	TimerGlobal.pause_timer()

	ConsoleLog.DEBUG(
		self,
		"Entered pause menu scene"
	)


func _entered_settings_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null

	ConsoleLog.DEBUG(
		self,
		"Entered settings menu scene"
	)


func _entered_load_game_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null

	ConsoleLog.DEBUG(
		self,
		"Entered load game menu scene"
	)



func _entered_save_game_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null

	ConsoleLog.DEBUG(
		self,
		"Entered save game menu scene"
	)


func _entered_new_game_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null

	ConsoleLog.DEBUG(
		self,
		"Entered new game menu scene"
	)


func _entered_campaign_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null

	ConsoleLog.DEBUG(
		self,
		"Entered campaign menu scene"
	)


func _entered_game_over_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	ConsoleLog.DEBUG(
		self,
		"Entered game over menu scene"
	)


func _entered_victory_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	ConsoleLog.DEBUG(
		self,
		"Entered victory menu scene"
	)


func _entered_inventory_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		else:
			_pause_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null
	TimerGlobal.pause_timer()

	ConsoleLog.DEBUG(
		self,
		"Entered inventory menu scene"
	)


func _entered_character_stats_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null

	ConsoleLog.DEBUG(
		self,
		"Entered character stats menu scene"
	)


func _entered_skill_leveling_menu_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			# _hide_node(current_active_scene_nodes_dictionary[resource])
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null

	ConsoleLog.DEBUG(
		self,
		"Entered skill leveling menu scene"
	)


func _entered_level_hud_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	ConsoleLog.DEBUG(
		self,
		"Entered level HUD scene"
	)


func _entered_combat_hud_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	ConsoleLog.DEBUG(
		self,
		"Entered combat HUD scene"
	)


func _entered_npc_interaction_hud_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	ConsoleLog.DEBUG(
		self,
		"Entered NPC interaction HUD scene"
	)


func _entered_level_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		if resource.is_scene_type == SCENE_TYPE.HUD:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	if last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL] != null:
		_unload_node(last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL], current_active_scene_nodes_dictionary[last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL]])
	else:
		ConsoleLog.DEBUG(
			self,
			"No previous level scene to unload"
		)

	if last_active_scene_resources_type_dictionary[SCENE_TYPE.COMBAT] != null:
		_unload_node(last_active_scene_resources_type_dictionary[SCENE_TYPE.COMBAT], current_active_scene_nodes_dictionary[last_active_scene_resources_type_dictionary[SCENE_TYPE.COMBAT]])
	else:
		ConsoleLog.DEBUG(
			self,
			"No previous combat scene to unload"
		)

	last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL] = null
	last_active_scene_resources_type_dictionary[SCENE_TYPE.MENU] = null
	last_active_scene_resources_type_dictionary[SCENE_TYPE.COMBAT] = null
	last_active_scene_resources_type_dictionary[SCENE_TYPE.HUD] = null

	load_scene("level_hud")

	ConsoleLog.DEBUG(
		self,
		"Entered level scene"
	)


func _entered_tutorial_combat_fight_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		if resource.is_scene_type == SCENE_TYPE.HUD:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	if last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL] != null:
		_deactivate_node(last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL], current_active_scene_nodes_dictionary[last_active_scene_resources_type_dictionary[SCENE_TYPE.LEVEL]])
	else:
		ConsoleLog.DEBUG(
			self,
			"No previous level scene to deactivate"
		)

	load_scene("combat_hud")

	ConsoleLog.DEBUG(
		self,
		"Entered tutorial combat fight scene"
	)


func _entered_random_encounter_combat_fight_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		if resource.is_scene_type == SCENE_TYPE.HUD:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	load_scene("combat_hud")

	ConsoleLog.DEBUG(
		self,
		"Entered random encounter combat fight scene"
	)


func _entered_mission_encounter_combat_fight_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		if resource.is_scene_type == SCENE_TYPE.HUD:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	load_scene("combat_hud")

	ConsoleLog.DEBUG(
		self,
		"Entered mission encounter combat fight scene"
	)


func _entered_boss_fight_combat_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		if resource.is_scene_type == SCENE_TYPE.HUD:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	load_scene("combat_hud")

	ConsoleLog.DEBUG(
		self,
		"Entered boss fight scene"
	)


func _entered_final_boss_fight_combat_scene(resource_to_load : Resource, node_to_load : Node) -> void:
	for resource in current_active_scene_nodes_dictionary.keys():
		if resource.is_scene_type == SCENE_TYPE.MENU:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])
		if resource.is_scene_type == SCENE_TYPE.HUD:
			_deactivate_node(resource, current_active_scene_nodes_dictionary[resource])

	load_scene("combat_hud")

	ConsoleLog.DEBUG(
		self,
		"Entered final boss fight scene"
	)












func _activate_node(resource_to_activate : Resource, node_to_activate : Node) -> void:
	if _check_scene_node_active(resource_to_activate) == null:
		_process_active_nodes_depending_on_type_and_subtype(resource_to_activate, node_to_activate)
		scene_types_main_nodes[resource_to_activate.is_scene_type].add_child(node_to_activate)
		current_active_scene_nodes_dictionary[resource_to_activate] = node_to_activate
		last_active_scene_resources_type_dictionary[resource_to_activate.is_scene_type] = resource_to_activate

		ConsoleLog.DEBUG(
			self,
			"Activated scene node: " + resource_to_activate.name
		)

		lookup_table_scene_types_sub_types_emit_loaded_signal[resource_to_activate.is_scene_type][resource_to_activate.is_scene_subtype].emit(EventBus.generate_signal_key())


func _deactivate_node(resource_to_deactivate : Resource, node_to_deactivate : Node) -> void:
	var main_node_scene_type : Node = scene_types_main_nodes[resource_to_deactivate.is_scene_type]
	var node_deactivated : bool = false

	if main_node_scene_type.has_node(node_to_deactivate.get_path()):
		main_node_scene_type.remove_child(node_to_deactivate)
		ConsoleLog.DEBUG(
			self,
			"Removed scene node from main node: " + resource_to_deactivate.name
		)
		node_deactivated = true
	else:
		ConsoleLog.WARNING(
			self,
			"Scene node not found in main node for deactivation: " + resource_to_deactivate.name
		)

	if current_active_scene_nodes_dictionary.erase(resource_to_deactivate):
		ConsoleLog.DEBUG(
			self,
			"Deactivated scene node from current_active_scene_nodes_dictionary: " + resource_to_deactivate.name
		)
	else:
		ConsoleLog.WARNING(
			self,
			"Scene node not found in current_active_scene_nodes_dictionary for deactivation: " + resource_to_deactivate.name
		)

	if node_deactivated:
		lookup_table_scene_types_sub_types_emit_unloaded_signal[resource_to_deactivate.is_scene_type][resource_to_deactivate.is_scene_subtype].emit(EventBus.generate_signal_key())


func _pause_node(resource_to_pause : Resource, node_to_pause : Node) -> void:
	node_to_pause.process_mode = Node.PROCESS_MODE_DISABLED
	ConsoleLog.DEBUG(
		self,
		"Paused scene node: " + resource_to_pause.name
	)


func _unpause_node(resource_to_unpause : Resource, node_to_unpause : Node) -> void:
	node_to_unpause.process_mode = Node.PROCESS_MODE_INHERIT
	ConsoleLog.DEBUG(
			self,
			"Unpaused scene node: " + resource_to_unpause.name
		)


func _show_node(resource_to_show : Resource, node_to_show : Node) -> void:
	node_to_show.show()
	node_to_show.process_mode = Node.PROCESS_MODE_INHERIT
	ConsoleLog.DEBUG(
		self,
		"Shown scene node: " + resource_to_show.name
	)


func _hide_node(resource_to_hide : Resource, node_to_hide : Node) -> void:
	node_to_hide.hide()
	node_to_hide.process_mode = Node.PROCESS_MODE_DISABLED
	ConsoleLog.DEBUG(
		self,
		"Hidden scene node: " + resource_to_hide.name
	)


func _unload_node(resource_to_unload : Resource, node_to_unload : Node) -> void:
	_deactivate_node(resource_to_unload, node_to_unload)

	if current_loaded_scene_nodes_dictionary.erase(resource_to_unload):
		ConsoleLog.DEBUG(
			self,
			"Unloaded scene node from current_loaded_scene_nodes_dictionary: " + resource_to_unload.name
		)
	else:
		ConsoleLog.WARNING(
			self,
			"Scene node not found in current_loaded_scene_nodes_dictionary for unloading: " + resource_to_unload.name
		)
	node_to_unload.queue_free()


func _load_node(resource_to_load : Resource) -> Node:
	var scene_node_to_switch_to : Node = _check_scene_node_loaded(resource_to_load)

	if scene_node_to_switch_to == null:
		scene_node_to_switch_to = resource_to_load.scene_file.instantiate()

	current_loaded_scene_nodes_dictionary[resource_to_load] = scene_node_to_switch_to

	ConsoleLog.DEBUG(
		self,
		"Loaded scene node: " + resource_to_load.name
	)

	return scene_node_to_switch_to















func _process_active_nodes_depending_on_type_and_subtype(resource_to_load : Resource, node_to_load : Node) -> void:
	var callable_function : Callable
	var scene_type_to_switch_to : SCENE_TYPE = resource_to_load.is_scene_type
	var scene_subtype_to_switch_to : int = resource_to_load.is_scene_subtype
	var scene_subtype_dictionary : Dictionary = lookup_table_scene_types_sub_types_process_active_nodes.get(scene_type_to_switch_to)

	if scene_subtype_dictionary == null:
		ConsoleLog.WARNING(
			self,
			"No callable functions found for scene type: " + _enum_to_string(scene_type_to_switch_to)
		)
		return

	callable_function = scene_subtype_dictionary.get(scene_subtype_to_switch_to)

	if callable_function == null:
		ConsoleLog.WARNING(
			self,
			"No callable functions found for scene subtype: " + str(scene_subtype_to_switch_to) + " of scene type: " + _enum_to_string(scene_type_to_switch_to)
		)
		return

	if callable_function.is_valid():
		callable_function.call(resource_to_load, node_to_load)
	else:
		ConsoleLog.ERROR(
			self,
			"Callable function is not valid for scene subtype: " + str(scene_subtype_to_switch_to) + " of scene type: " + _enum_to_string(scene_type_to_switch_to)
		)














func load_scene(resource_name_to_load : String) -> void:
	if not _check_initialization():
		return

	var scene_resource_to_load : Resource = _check_resource_exists(resource_name_to_load)

	if scene_resource_to_load != null:
		var scene_node_to_load : Node = _load_node(scene_resource_to_load)
		_activate_node(scene_resource_to_load, scene_node_to_load)



func unload_scene(resource_name_to_unload : String) -> void:
	pass
