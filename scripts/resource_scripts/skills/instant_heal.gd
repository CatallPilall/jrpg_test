extends skill_fragment

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, _skill_duration : int):
	if turn_one:
		var caster_healing_strength : float = caster.active_stats.get("healing_strength")
		var caster_crit_chance : float = caster.active_stats.get("crit_chance")
		var target_max_health : float = target.base_stats.get("health_points")
		var target_current_health : float = target.active_stats.get("health_points")
		
		var caster_scaling : float = caster.active_stats.get(get_scaling_stat(true)) * caster_scaling_stat
		var target_scaling : float = caster.active_stats.get(get_scaling_stat(false)) * target_stat_scaling
		
		var heal_amount : float = (base_value + caster_scaling + target_scaling) * caster_healing_strength
		var target_new_health : float = target_current_health + heal_amount
		
		if base_crit_chance + caster_crit_chance < roll_d_hundred():
			if target_new_health > target_max_health:
				target.active_stats.set("health_points",target_max_health)
		
		target.active_stats.set("health_points",target_new_health)
