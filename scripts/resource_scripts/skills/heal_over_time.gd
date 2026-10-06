extends skill_fragment

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if not turn_one:
		if skill_duration > 0:
			var heal_strength : float = base_value * (stat_scaling * caster.active_stats.get("healing_efficiency"))
			var crit_chance : float = base_crit_chance + caster.active_stats.get("crit_chance")
			
			if roll_d_hundred() < crit_chance:
				heal_strength = heal_strength * (1 + caster.active_stats.get("crit_efficiency")/100)
			
			var target_max_health : float = target.base_stats.get("health_points")
			var target_new_health : float = target.active_stats.get("health_points") + heal_strength
			
			if target_new_health > target_max_health:
				target.active_stats.set("health_points",target_max_health)
			else:
				target.active_stats.set("health_points",target_new_health)
