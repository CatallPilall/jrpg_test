extends Node

var signal_key_counter : int = 10

func generate_signal_key() -> int:
	signal_key_counter = signal_key_counter + 1
	return signal_key_counter

@warning_ignore("unused_signal")
signal display_unit_info(selected_unit : unit, signal_key : int)

# Signals for scenes ------------------------------------------------------------
# LOADED
# MENU
# HUD
# @warning_ignore("unused_signal")
# signal combat_hud_has_loaded(called_by : Node, signal_key : int)
# LEVELS
# COMBAT

# UNLOADED
# MENU
# HUD
# LEVELS
# COMBAT

# ACTIVATED
# MENU
# HUD
# LEVELS
# COMBAT

# DEACTIVATED
# MENU
# HUD
# LEVELS
# COMBAT
# -------------------------------------------------------------------------------


# Signals for combat_manager ----------------------------------------------------
@warning_ignore("unused_signal")
signal combat_started(signal_key : int)
@warning_ignore("unused_signal")
signal skill_button_pressed(skill_pressed : skill, signal_key : int)
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
signal remove_combat_hud_skill_buttons(signal_key : int)
@warning_ignore("unused_signal")
signal apply_skill_targeting(primary_targeting : skill.enum_skill_targeting, secondary_targeting : skill.enum_skill_targeting, casting_unit : unit, signal_key : int)
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


# Signal for Keyboard input -----------------------------------------------------
@warning_ignore("unused_signal")
signal interact_pressed(signal_key : int)
# -------------------------------------------------------------------------------


# Signal to play Spatial_Audio_effects ------------------------------------------
@warning_ignore("unused_signal")
signal play_spatial_audio_effects(signal_key : int)
# -------------------------------------------------------------------------------


# Signal from Music/SFX-Player --------------------------------------------------
@warning_ignore("unused_signal")
signal song_started(signal_key : int)
@warning_ignore("unused_signal")
signal song_ended(signal_key : int)
@warning_ignore("unused_signal")
signal song_paused(signal_key : int)
@warning_ignore("unused_signal")
signal song_resumed(signal_key : int)
@warning_ignore("unused_signal")
signal sfx_started(signal_key : int)
@warning_ignore("unused_signal")
signal sfx_ended(signal_key : int)
@warning_ignore("unused_signal")
signal sfx_paused(signal_key : int)
@warning_ignore("unused_signal")
signal sfx_resumed(signal_key : int)
# -------------------------------------------------------------------------------


# Signals for Scene preperation -------------------------------------------------
@warning_ignore("unused_signal")
signal prepare_scene(called_by : Node, arguments : Array, signal_key : int)
# -------------------------------------------------------------------------------


# Signals for skills and relics -------------------------------------------------
@warning_ignore("unused_signal")
signal block_stance_triggered(target : unit, postmitigated_damage_array : Array[float], signal_key : int)
@warning_ignore("unused_signal")
signal parry_stance_triggered(target : unit, activating_skill : skill, signal_key : int)
@warning_ignore("unused_signal")
signal retaliate_stance_triggered(caster : unit, target : unit, signal_key : int)
@warning_ignore("unused_signal")
signal counterspell_stance_triggered(caster : unit, activating_skill_fragment : skill_fragment, signal_key : int)
@warning_ignore("unused_signal")
signal chase_stance_triggered(caster : unit, target : unit, signal_key : int)
@warning_ignore("unused_signal")
signal guard_stance_triggered(primary_targets : Array[unit], signal_key : int)
# -------------------------------------------------------------------------------

@warning_ignore("unused_signal")
signal set_current_button_focus(new_button_focus : Button, signal_key : int)

# Signals for Timer -------------------------------------------------------------
@warning_ignore("unused_signal")
signal timer_updated(time_as_string : String, signal_key : int)
# -------------------------------------------------------------------------------


func connect_function_with_signal(called_by : Object, function_to_connect : Callable, signal_connect_to : Signal) -> void:
	if not function_to_connect.is_valid():
		ConsoleLog.ERROR("function is not valid")
		return

	if not signal_connect_to.is_connected(function_to_connect):
		signal_connect_to.connect(function_to_connect)
		ConsoleLog.SIGNAL(signal_connect_to, "connected with " + called_by.get_name() + "::" + function_to_connect.get_method(), 1)
	else:
		ConsoleLog.WARNING(function_to_connect.get_method() + " is already connected to signal: " + signal_connect_to.get_name())


func disconnect_function_from_signal(called_by : Object, function_to_disconnect : Callable, signal_disconnect_from : Signal) -> void:
	if not function_to_disconnect.is_valid():
		ConsoleLog.ERROR("function is not valid")
		return

	if signal_disconnect_from.is_connected(function_to_disconnect):
		signal_disconnect_from.disconnect(function_to_disconnect)
		ConsoleLog.SIGNAL(signal_disconnect_from, "disconnected with " + called_by.get_name() + "::" + function_to_disconnect.get_method(), 0)
	else:
		ConsoleLog.WARNING(function_to_disconnect.get_method() + " is not connected to signal: " + signal_disconnect_from.get_name())


func connect_functions_with_signals(called_by : Object, functions_to_connect_to_signals : Dictionary[Callable, Signal]) -> void:
	for function_to_connect in functions_to_connect_to_signals.keys():
		var signal_connect_to : Signal = functions_to_connect_to_signals[function_to_connect]
		connect_function_with_signal(called_by, function_to_connect, signal_connect_to)


func disconnect_functions_from_signals(called_by : Object, functions_to_disconnect_from_signals : Dictionary[Callable, Signal]) -> void:
	for function_to_disconnect in functions_to_disconnect_from_signals.keys():
		var signal_disconnect_from : Signal = functions_to_disconnect_from_signals[function_to_disconnect]
		disconnect_function_from_signal(called_by, function_to_disconnect, signal_disconnect_from)


func _emit_signal(logging : bool, signal_to_emit : Signal, args_for_signal : Array = [], signal_key : int = -1) -> void:
	if not signal_to_emit.has_connections():
		if logging:
			ConsoleLog.WARNING("signal " + signal_to_emit.get_name() + " does not have any connections")
		return

	if signal_key == -1:
		signal_key = generate_signal_key()

	args_for_signal.append(signal_key)
	if logging:
		ConsoleLog.SIGNAL(signal_to_emit, "emit", signal_key)
	signal_to_emit.emit.callv(args_for_signal)


func emit_signal_with_log(signal_to_emit : Signal, args_for_signal : Array = [], signal_key : int = -1) -> void:
	_emit_signal(true, signal_to_emit, args_for_signal, signal_key)


func emit_signal_no_log(signal_to_emit : Signal, args_for_signal : Array = [], signal_key : int = -1) -> void:
	_emit_signal(false, signal_to_emit, args_for_signal, signal_key)
