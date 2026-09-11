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
