extends skill_fragment

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if not turn_one:
		if skill_duration > 0:
			match damage_type:
				enum_damage_type.BLEED:
					execute_bleeding(caster, target)
				enum_damage_type.POI:
					execute_poisoned(caster, target)
			if skill_duration == 1:
				if target.bleed_dots.has(self):
					target.bleed_dots.erase(self)
				if target.poison_dots.has(self):
					target.poison_dots.erase(self)
			ConsoleLog.DEBUG(self,"dot_duration: " + str(skill_duration))
	else :
		match damage_type:
			enum_damage_type.BLEED:
				apply_bleed(caster, target)
			enum_damage_type.POI:
				apply_poison(caster, target)

func apply_bleed(caster : unit, target : unit):
	var cast : float = roll_d_hundred() + base_value + caster.active_stats.get("status_damage")
	var target_resistance : float = target.active_stats.get("status_def")
	
	if cast > target_resistance:
		target.bleed_dots.append(self)
		ConsoleLog.DEBUG(self, " bleed applied")
	else:
		ConsoleLog.DEBUG(self," bleed resisted")

func apply_poison(caster : unit, target : unit):
	var cast : float = roll_d_hundred() + base_value * caster.active_stats.get("poi_efficiency")/100
	var target_resistance : float = target.active_stats.get("status_def")
	
	if cast > target_resistance:
		target.poison_dots.append(self)
		ConsoleLog.DEBUG(self, " poison applied")
	else:
		ConsoleLog.DEBUG(self, " poison resisted")

func execute_bleeding(caster : unit, target : unit):
	if target.bleed_dots.has(self):
		var resulting_damage : float = base_value + base_value * caster.active_stats.get("status_damage")/100
		var negated_damage : float = resulting_damage * (100 - target.active_stats.get("phys_def"))/100
		var remaining_target_health : int = roundi(target.active_stats.get("health_points") - negated_damage)
		target.active_stats.set("health_points",remaining_target_health)
		ConsoleLog.INFO(self,["resulting_damage","negated_damage"],[resulting_damage,negated_damage])

func execute_poisoned(caster : unit, target : unit):
	if target.poison_dots.has(self):
		var resulting_damage : float = base_value + base_value * caster.active_stats.get("poi_efficiency")/100
		var negated_damage : float = resulting_damage * (100 - target.active_stats.get("poi_def"))/100
		var remaining_target_health : int = roundi(target.active_stats.get("health_points") - negated_damage)
		target.active_stats.set("health_points",remaining_target_health)
		ConsoleLog.INFO(self,["resulting_damage","negated_damage"],[resulting_damage,negated_damage])

func reverse_buff(_target : unit):
	pass
