extends Node

var signal_key_counter : int = 10

func generate_signal_key() -> int:
	signal_key_counter = signal_key_counter +1
	return signal_key_counter

@warning_ignore("unused_signal")
signal execute_attack_skill(signal_key : int)
@warning_ignore("unused_signal")
signal display_unit_info(selected_unit : unit,signal_key : int)
@warning_ignore("unused_signal")
signal load_ui_scene(ui_scene : Control,signal_key : int)
@warning_ignore("unused_signal")
signal load_scene(scene : Node2D,signal_key : int)
@warning_ignore("unused_signal")
signal load_hud_scene(hud_scene : Control,signal_key : int)

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
signal combat_attack_button(signal_key : int)
@warning_ignore("unused_signal")
signal combat_guard_button(signal_key : int)
@warning_ignore("unused_signal")
signal combat_channel_button(signal_key : int)
@warning_ignore("unused_signal")
signal combat_skill_button(signal_key : int)
@warning_ignore("unused_signal")
signal combat_item_button(signal_key : int)
# -------------------------------------------------------------------------------
