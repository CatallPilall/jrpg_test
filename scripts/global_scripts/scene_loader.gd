extends Node

# ENUM for scene types, used to identify and load different scenes in the game.
# The values are powers of 2, allowing for bitwise operations to check for multiple scene types.
# WICHTIG: The names of the enum values must match the names of the corresponding .tscn files for proper loading.
# BITTE AUF NAMENSGEBUNG ACHTEN BEI DEN SCENEN UND ENTSPRECHEND ENUM ERWEITERN
enum SCENE_TYPE {
	NONE = 0,
	MAIN_MENU = 1,
	CAMPAIGN_MENU = 2,
	PAUSE_MENU = 4,
	INVENTORY_MENU = 8,
	LEVEL_HUD = 16,
	COMBAT_HUD = 32,
	LEVEL = 64,
	COMBAT = 128,
}

var menu_canvas_layer : CanvasLayer
var hud_canvas_layer : CanvasLayer
var combat_scenes : Node
var level_scenes : Node

var current_menu_scene : Control
var current_hud_scene : Control
var current_level_scene : Node2D
var current_combat_scene : combat_scene

# var main_menu_packed_scene : PackedScene = preload("res://scenes/UI_scenes/main_menu.tscn")
# var campaign_menu_packed_scene : PackedScene = preload("res://scenes/UI_scenes/campaign_menu.tscn")
# var pause_menu_packed_scene : PackedScene = preload("res://scenes/UI_scenes/pause_menu.tscn")
# var inventory_menu_packed_scene : PackedScene = preload("res://scenes/UI_scenes/inventory_menu.tscn")
# var combat_hud_packed_scene : PackedScene = preload("res://scenes/UI_scenes/combat_hud.tscn")
# var level_hud_packed_scene : PackedScene = preload("res://scenes/UI_scenes/level_hud.tscn")

const LEVEL_SCENES_PATH : String = "res://scenes/level_scenes/"
const COMBAT_SCENES_PATH : String = "res://scenes/combat_scenes/"
const HUD_SCENES_PATH : String = "res://scenes/UI_scenes/hud_scenes/"
const MENU_SCENES_PATH : String = "res://scenes/UI_scenes/menu_scenes/"

var level_packed_scenes_array : Array[PackedScene]
var combat_packed_scenes_array : Array[PackedScene]

## Dictionary to hold UI scenes with their corresponding SCENE_TYPE as keys
## This allows for easy retrieval of UI scenes based on their type.
## ONLY HUD and MENU SCENES should be stored in this dictionary, as they are the only ones that can be loaded via SCENE_TYPE enum.
var ui_packed_scenes_dictionary : Dictionary[SCENE_TYPE, PackedScene]

var ui_scene_loaded : Dictionary[SCENE_TYPE, Control] = {}
var level_scene_loaded : Dictionary[int, Node2D] = {}
var combat_scene_loaded : Dictionary[int, combat_scene] = {}

var is_initialized : bool = false


func _init() -> void:
	# This function is called when the node is initialized.
	# You can perform any necessary setup here.
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_packed_scenes()


func _check_initialization() -> bool:
	if not is_initialized:
		ConsoleLog.ERROR(self, "SceneLoader 33", "SceneLoader has not been initialized. Please call init_vars() from Main.gd before using SceneLoader.")
		return false
	return true


func _enum_to_string(scene_type: SCENE_TYPE) -> String:
	var key_name = SCENE_TYPE.find_key(scene_type)
	if key_name != null:
		return key_name
	return "UNKNOWN"


func _string_to_enum(scene_type_str : String) -> SCENE_TYPE:
	return SCENE_TYPE.get(scene_type_str, SCENE_TYPE.NONE)


func _show_ui_scene(scenes_to_show : Array[SCENE_TYPE]) -> void:
	for scene_type in scenes_to_show:
		if ui_scene_loaded.has(scene_type):
			ui_scene_loaded[scene_type].show()
		else:
			ConsoleLog.ERROR(self, "SceneLoader 55", "UI scene not loaded or does not exist for type: " + _enum_to_string(scene_type))


func _hide_ui_scene(scenes_to_hide : Array[SCENE_TYPE]) -> void:
	for scene_type in scenes_to_hide:
		if ui_scene_loaded.has(scene_type):
			ui_scene_loaded[scene_type].hide()
		else:
			ConsoleLog.ERROR(self, "SceneLoader 55", "UI scene not loaded or does not exist for type: " + _enum_to_string(scene_type))


func _scene_has_loaded(loaded_scene_type : SCENE_TYPE) -> void:
	var new_signal_key : int = EventBus.generate_signal_key()

	match loaded_scene_type:
		SCENE_TYPE.MAIN_MENU:
			ConsoleLog.SIGNAL(self, "main_menu_has_loaded", "emit", new_signal_key)
			EventBus.main_menu_has_loaded.emit(new_signal_key)
		SCENE_TYPE.CAMPAIGN_MENU:
			ConsoleLog.SIGNAL(self, "campaign_menu_has_loaded", "emit", new_signal_key)
			EventBus.campaign_menu_has_loaded.emit(new_signal_key)
		SCENE_TYPE.PAUSE_MENU:
			ConsoleLog.SIGNAL(self, "pause_menu_has_loaded", "emit", new_signal_key)
			EventBus.pause_menu_has_loaded.emit(new_signal_key)
		SCENE_TYPE.INVENTORY_MENU:
			ConsoleLog.SIGNAL(self, "inventory_menu_has_loaded", "emit", new_signal_key)
			EventBus.inventory_menu_has_loaded.emit(new_signal_key)
		SCENE_TYPE.LEVEL_HUD:
			ConsoleLog.SIGNAL(self, "level_hud_has_loaded", "emit", new_signal_key)
			EventBus.level_hud_has_loaded.emit(new_signal_key)
		SCENE_TYPE.COMBAT_HUD:
			ConsoleLog.SIGNAL(self, "combat_hud_has_loaded", "emit", new_signal_key)
			EventBus.combat_hud_has_loaded.emit(new_signal_key)
		SCENE_TYPE.LEVEL:
			ConsoleLog.SIGNAL(self, "level_has_loaded", "emit", new_signal_key)
			EventBus.level_has_loaded.emit(new_signal_key)
		SCENE_TYPE.COMBAT:
			ConsoleLog.SIGNAL(self, "combat_has_loaded", "emit", new_signal_key)
			EventBus.combat_has_loaded.emit(new_signal_key)
		_:
			ConsoleLog.ERROR(self, "SceneLoader 62", "Unknown scene type: " + _enum_to_string(loaded_scene_type))


func _scene_has_unloaded(unloaded_scene_type : SCENE_TYPE) -> void:
	var new_signal_key : int = EventBus.generate_signal_key()

	match unloaded_scene_type:
		SCENE_TYPE.MAIN_MENU:
			ConsoleLog.SIGNAL(self, "main_menu_has_unloaded", "emit", new_signal_key)
			EventBus.main_menu_has_unloaded.emit(new_signal_key)
		SCENE_TYPE.CAMPAIGN_MENU:
			ConsoleLog.SIGNAL(self, "campaign_menu_has_unloaded", "emit", new_signal_key)
			EventBus.campaign_menu_has_unloaded.emit(new_signal_key)
		SCENE_TYPE.PAUSE_MENU:
			ConsoleLog.SIGNAL(self, "pause_menu_has_unloaded", "emit", new_signal_key)
			EventBus.pause_menu_has_unloaded.emit(new_signal_key)
		SCENE_TYPE.INVENTORY_MENU:
			ConsoleLog.SIGNAL(self, "inventory_menu_has_unloaded", "emit", new_signal_key)
			EventBus.inventory_menu_has_unloaded.emit(new_signal_key)
		SCENE_TYPE.LEVEL_HUD:
			ConsoleLog.SIGNAL(self, "level_hud_has_unloaded", "emit", new_signal_key)
			EventBus.level_hud_has_unloaded.emit(new_signal_key)
		SCENE_TYPE.COMBAT_HUD:
			ConsoleLog.SIGNAL(self, "combat_hud_has_unloaded", "emit", new_signal_key)
			EventBus.combat_hud_has_unloaded.emit(new_signal_key)
		SCENE_TYPE.LEVEL:
			ConsoleLog.SIGNAL(self, "level_has_unloaded", "emit", new_signal_key)
			EventBus.level_has_unloaded.emit(new_signal_key)
		SCENE_TYPE.COMBAT:
			ConsoleLog.SIGNAL(self, "combat_has_unloaded", "emit", new_signal_key)
			EventBus.combat_has_unloaded.emit(new_signal_key)
		_:
			ConsoleLog.ERROR(self, "SceneLoader 91", "Unknown scene type: " + _enum_to_string(unloaded_scene_type))



# sollte alle packedscenes beinhalten um diese einfach mit ner funktion zu laden;
# finde es passt besser als mit signals das zu machen, da wir später zum speichern bzw. laden die current scenen brauchen
# bzw. auch so sachen wie pos des players und status und so könnte man hier abspeichern und laden bzw. setzen
# die scenen werden aus den entsprechenden ordnern geladen und in den arrays/dict gespeichert, damit man sie einfach laden kann
# man kann es über load statt preload machen, da diese klasse ein global singleton ist, und genau am anfang des spiels geladen werden (loading screen bevor main_menu)
# WICHTIG: nur HUD und MENU SCENES werden in dem DICT gespeichert, da diese über den SCENE_TYPE geladen werden können, die anderen nicht
# AUCH WICHTIG: die SCENE_TYPE ENUMS müssen den gleichen namen haben wie die entsprechenden tscn dateien, damit sie geladen werden können
# ALSO BITTE AUF NAMENSGEBUNG ACHTEN BEI DEN SCENEN UND ENTSPRECHEND ENUM ERWEITERN
func _load_packed_scenes() -> void:
	for level_scene_name in DirAccess.open(LEVEL_SCENES_PATH).get_files():
		if level_scene_name.ends_with(".tscn"):
			level_packed_scenes_array.append(load(LEVEL_SCENES_PATH + level_scene_name))
			ConsoleLog.DEBUG(self, "Loaded level scene into level_packed_scenes_array: " + str(level_scene_name))

	for combat_scene_name in DirAccess.open("res://scenes/combat_scenes/").get_files():
		if combat_scene_name.ends_with(".tscn"):
			combat_packed_scenes_array.append(load(COMBAT_SCENES_PATH + combat_scene_name))
			ConsoleLog.DEBUG(self, "Loaded combat scene into combat_packed_scenes_array: " + str(combat_scene_name))

	for menu_scene_name in DirAccess.open(MENU_SCENES_PATH).get_files():
		if menu_scene_name.ends_with(".tscn"):
			ui_packed_scenes_dictionary[_string_to_enum(menu_scene_name.get_basename().to_upper())] = load(MENU_SCENES_PATH + menu_scene_name)
			ConsoleLog.DEBUG(self, "Loaded menu scene into ui_packed_scenes_dictionary: " + str(menu_scene_name))

	for hud_scene_name in DirAccess.open(HUD_SCENES_PATH).get_files():
		if hud_scene_name.ends_with(".tscn"):
			ui_packed_scenes_dictionary[_string_to_enum(hud_scene_name.get_basename().to_upper())] = load(HUD_SCENES_PATH + hud_scene_name)
			ConsoleLog.DEBUG(self, "Loaded HUD scene into ui_packed_scenes_dictionary: " + str(hud_scene_name))


## Initalisierung der Variablen, die von Main.gd übergeben werden;
## Zu übergebene Nodes befinden sich im Main Node
func init_vars(_called_by : Object, _menu_canvas_layer : CanvasLayer, _hud_canvas_layer : CanvasLayer, _combat_scenes : Node, _level_scenes : Node) -> void:
	if _called_by.get_script().get_global_name() != "Main":
		ConsoleLog.ERROR(self, "SceneLoader 42", "SceneLoader.init_vars() can only be called from Main.gd")
		return
	menu_canvas_layer = _menu_canvas_layer
	hud_canvas_layer = _hud_canvas_layer
	combat_scenes = _combat_scenes
	level_scenes = _level_scenes

	is_initialized = true


func load_scene(scene_type_to_load : SCENE_TYPE, level_num_id : int = -1, combat_num_id : int = -1) -> Node:
	if not _check_initialization():
		return null

	var scene_loaded_bool : bool = true
	var loaded_scene_node : Node = null

	var scene_menu_mask : int = SCENE_TYPE.MAIN_MENU | SCENE_TYPE.CAMPAIGN_MENU | SCENE_TYPE.PAUSE_MENU | SCENE_TYPE.INVENTORY_MENU
	var scene_hud_mask : int = SCENE_TYPE.LEVEL_HUD | SCENE_TYPE.COMBAT_HUD
	var scene_level_mask : int = SCENE_TYPE.LEVEL
	var scene_combat_mask : int = SCENE_TYPE.COMBAT

	var exclude_scene_type_to_load_from_array_to_hide = func(exclude_type : SCENE_TYPE) -> Array[SCENE_TYPE]:
		var enum_keys = SCENE_TYPE.keys()
		var exclude_array : Array[SCENE_TYPE] = []
		for key in enum_keys:
			if key == "NONE":
				continue
			if key.contains("HUD") or key.contains("MENU"):
				var scene_type : SCENE_TYPE = SCENE_TYPE[key]
				if scene_type != exclude_type:
					exclude_array.append(scene_type)
		return exclude_array

	if scene_type_to_load & scene_menu_mask != 0:
		if not ui_scene_loaded.has(scene_type_to_load):
			current_menu_scene = ui_packed_scenes_dictionary[scene_type_to_load].instantiate()
			menu_canvas_layer.add_child(current_menu_scene)
			ui_scene_loaded[scene_type_to_load] = current_menu_scene
		else:
			current_menu_scene = ui_scene_loaded[scene_type_to_load]

		_hide_ui_scene(exclude_scene_type_to_load_from_array_to_hide.call(scene_type_to_load))
		_show_ui_scene([scene_type_to_load])
		loaded_scene_node = current_menu_scene

	elif scene_type_to_load & scene_hud_mask != 0:
		if not ui_scene_loaded.has(scene_type_to_load):
			current_hud_scene = ui_packed_scenes_dictionary[scene_type_to_load].instantiate()
			hud_canvas_layer.add_child(current_hud_scene)
			ui_scene_loaded[scene_type_to_load] = current_hud_scene
		else:
			current_hud_scene = ui_scene_loaded[scene_type_to_load]

		_hide_ui_scene(exclude_scene_type_to_load_from_array_to_hide.call(scene_type_to_load))
		_show_ui_scene([scene_type_to_load])
		loaded_scene_node = current_hud_scene

	elif scene_type_to_load & scene_level_mask != 0 && level_num_id != -1:
		current_level_scene = level_packed_scenes_array[level_num_id].instantiate()
		level_scenes.add_child(current_level_scene)
		loaded_scene_node = current_level_scene
		current_menu_scene.hide()

	elif scene_type_to_load & scene_combat_mask != 0 && combat_num_id != -1:
		current_combat_scene = combat_packed_scenes_array[combat_num_id].instantiate()
		combat_scenes.add_child(current_combat_scene)
		loaded_scene_node = current_combat_scene
		current_level_scene.hide()

	else:
		ConsoleLog.ERROR(self, "SceneLoader 47", "Invalid scene type for load_scene: " + _enum_to_string(scene_type_to_load))
		scene_loaded_bool = false

	if scene_loaded_bool:
		_scene_has_loaded(scene_type_to_load)

	return loaded_scene_node


func unload_scene(scene_type_to_unload : SCENE_TYPE, level_num_id : int = -1, combat_num_id : int = -1) -> bool:
	if not _check_initialization():
		return false

	var scene_unloaded = true

	var scene_menu_mask : int = SCENE_TYPE.MAIN_MENU | SCENE_TYPE.CAMPAIGN_MENU | SCENE_TYPE.PAUSE_MENU | SCENE_TYPE.INVENTORY_MENU
	var scene_hud_mask : int = SCENE_TYPE.LEVEL_HUD | SCENE_TYPE.COMBAT_HUD
	var scene_level_mask : int = SCENE_TYPE.LEVEL
	var scene_combat_mask : int = SCENE_TYPE.COMBAT

	return scene_unloaded
