extends Node

var signal_key_counter : int = 10

func generate_signal_key() -> int:
	signal_key_counter = signal_key_counter +1
	return signal_key_counter

@warning_ignore("unused_signal")
signal display_unit_info(selected_unit : unit,signal_key : int)
@warning_ignore("unused_signal")
signal load_ui_scene(ui_scene : Control,signal_key : int)
@warning_ignore("unused_signal")
signal load_scene(scene : Node2D,signal_key : int)
@warning_ignore("unused_signal")
signal load_combat_scene(scene : combat_scene, signal_key : int)
@warning_ignore("unused_signal")
signal unload_combat_scene(overworld_encounter : Node2D,signal_key : int)
@warning_ignore("unused_signal")
signal load_hud_scene(hud_scene : Control,signal_key : int)
@warning_ignore("unused_signal")
signal hud_scene_has_loaded(signal_key : int)

# Signals for day timer control -------------------------------------------------
@warning_ignore("unused_signal")
signal day_timer_timout(signal_key : int)
@warning_ignore("unused_signal")
signal set_and_start_day_timer(signal_key : int)
@warning_ignore("unused_signal")
signal pause_day_timer(signal_key : int)
@warning_ignore("unused_signal")
signal unpause_day_timer(signal_key : int)
# -------------------------------------------------------------------------------

# Signals for combat_manager ----------------------------------------------------
@warning_ignore("unused_signal")
signal skill_button_pressed(skill_pressed : String, signal_key : int)
@warning_ignore("unused_signal")
signal unit_targets_selected(targets : Array[unit], signal_key : int)
@warning_ignore("unused_signal")
signal end_turn_button_pressed(signal_key : int)
@warning_ignore("unused_signal")
signal new_selected_unit(selected_unit : unit, signal_key : int)
@warning_ignore("unused_signal")
signal remove_dead_unit(dead_unit : unit, signal_key : int)
@warning_ignore("unused_signal")
signal clean_up_skill(skill_to_clean : skill, signal_key : int)
# -------------------------------------------------------------------------------
