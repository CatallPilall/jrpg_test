extends skill_fragment

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if not turn_one:
		if skill_duration > 0:
			var caster_healing_strength : float = caster.active_stats.get("healing_strength")
			var caster_crit_chance : float = caster.active_stats.get("crit_chance")
			var target_max_health : float = target.base_stats.get("health_points")
			var target_current_health : float = target.active_stats.get("health_points")
			
			var heal_amount : float = (base_value + target_stat_scaling * target.active_stats.get(get_scaling_stat(false))) * caster_healing_strength
			var target_new_health : float = target_current_health + heal_amount
			
			if base_crit_chance + caster_crit_chance < roll_d_hundred():
				if target_new_health > target_max_health:
					target.active_stats.set("health_points",target_max_health)
			
			target.active_stats.set("health_points",target_new_health)
