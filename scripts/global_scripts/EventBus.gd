extends Node

var signal_key_counter : int = 10

func generate_signal_key() -> int:
	signal_key_counter = signal_key_counter +1
	return signal_key_counter

@warning_ignore("unused_signal")
signal display_unit_info(selected_unit : unit,signal_key : int)

# Signals for scene_loader ------------------------------------------------------
# LOADED
# UI
@warning_ignore("unused_signal")
signal main_menu_has_loaded(signal_key : int)
@warning_ignore("unused_signal")
signal campaign_menu_has_loaded(signal_key : int)
@warning_ignore("unused_signal")
signal pause_menu_has_loaded(signal_key : int)
@warning_ignore("unused_signal")
signal inventory_menu_has_loaded(signal_key : int)

# HUD
@warning_ignore("unused_signal")
signal level_hud_has_loaded(signal_key : int)
@warning_ignore("unused_signal")
signal combat_hud_has_loaded(signal_key : int)

# LEVELS
@warning_ignore("unused_signal")
signal level_has_loaded(signal_key : int)
@warning_ignore("unused_signal")
signal combat_has_loaded(signal_key : int)

# UNLOADED
# UI
@warning_ignore("unused_signal")
signal main_menu_has_unloaded(signal_key : int)
@warning_ignore("unused_signal")
signal campaign_menu_has_unloaded(signal_key : int)
@warning_ignore("unused_signal")
signal pause_menu_has_unloaded(signal_key : int)
@warning_ignore("unused_signal")
signal inventory_menu_has_unloaded(signal_key : int)

# HUD
@warning_ignore("unused_signal")
signal level_hud_has_unloaded(signal_key : int)
@warning_ignore("unused_signal")
signal combat_hud_has_unloaded(signal_key : int)

# LEVELS
@warning_ignore("unused_signal")
signal level_has_unloaded(signal_key : int)
@warning_ignore("unused_signal")
signal combat_has_unloaded(signal_key : int)
# -------------------------------------------------------------------------------


# Signals for combat_manager ----------------------------------------------------
@warning_ignore("unused_signal")
signal combat_started(signal_key : int)
@warning_ignore("unused_signal")
signal skill_button_pressed(item_skill : skill, skill_pressed : String, signal_key : int)
@warning_ignore("unused_signal")
signal unit_targets_selected(primary_targets : Array[unit], secondary_targets : Array[unit], signal_key : int)
@warning_ignore("unused_signal")
signal end_turn_button_pressed(signal_key : int)
@warning_ignore("unused_signal")
signal new_selected_unit(selected_unit : unit, signal_key : int)
@warning_ignore("unused_signal")
signal remove_dead_unit(dead_unit : unit, signal_key : int)
@warning_ignore("unused_signal")
signal clean_up_skill(skill_to_clean : skill, signal_key : int)
@warning_ignore("unused_signal")
signal disable_combat_hud_actions(signal_key : int)
@warning_ignore("unused_signal")
signal enable_combat_hud_actions(signal_key : int)
@warning_ignore("unused_signal")
signal combat_turn_ended(signal_key : int)
@warning_ignore("unused_signal")
signal make_combat_hud_skill_buttons(unit_skills : Array[String], signal_key : int)
@warning_ignore("unused_signal")
signal remove_combat_hud_skill_buttons(signal_key : int)
@warning_ignore("unused_signal")
signal apply_skill_targeting(primary_targeting : skill.enum_skill_targeting, secondary_targeting : skill.enum_skill_targeting, casting_unit : unit ,signal_key : int)
@warning_ignore("unused_signal")
signal combat_state_changed_via_combat_hud(signal_key : int)
@warning_ignore("unused_signal")
signal make_combat_hud_item_buttons(signal_key : int)
@warning_ignore("unused_signal")
signal item_button_pressed(item_pressed : item, signal_key : int)
@warning_ignore("unused_signal")
signal disable_item_button(disabled : bool, signal_key : int)
@warning_ignore("unused_signal")
signal combat_ended(signal_key : int)
# -------------------------------------------------------------------------------
# Signals for skills and relics -------------------------------------------------
@warning_ignore("unused_signal")
signal new_turn(signal_key : int)
@warning_ignore("unused_signal")
signal calculating_skill_speed(caster : unit, casted_skill : skill, signal_key : int)
# -------------------------------------------------------------------------------


func connect_function_with_signal(called_by : Object, function_to_connect : Callable, signal_connect_to : Signal) -> void:
	if not function_to_connect.is_valid():
		ConsoleLog.ERROR(self, "EventBus 84", "function is not valid; " + "called by: " + called_by.get_name())
		return

	if not signal_connect_to.is_connected(function_to_connect):
		signal_connect_to.connect(function_to_connect)
		ConsoleLog.SIGNAL(self, signal_connect_to.get_name(), "connected with " + called_by.get_name() + "::" + function_to_connect.get_method(), 1)
	else:
		ConsoleLog.WARNING(self, "EventBus 88", called_by.get_name() + "::" + function_to_connect.get_method() + " is already connected to signal: " + signal_connect_to.get_name())


func disconnect_function_from_signal(called_by : Object, function_to_disconnect : Callable, signal_disconnect_from : Signal) -> void:
	if not function_to_disconnect.is_valid():
		ConsoleLog.ERROR(self, "EventBus 96", "function is not valid")
		return

	if signal_disconnect_from.is_connected(function_to_disconnect):
		signal_disconnect_from.disconnect(function_to_disconnect)
		ConsoleLog.SIGNAL(self, signal_disconnect_from.get_name(), "disconnected with " + called_by.get_name() + "::" + function_to_disconnect.get_method(), 0)
	else:
		ConsoleLog.WARNING(self, "EventBus 100",  called_by.get_name() + "::" + function_to_disconnect.get_method() + " is not connected to signal: " + signal_disconnect_from.get_name())
