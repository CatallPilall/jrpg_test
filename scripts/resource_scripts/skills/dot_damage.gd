extends skill_fragment

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if not turn_one:
		if skill_duration > 0:
			match damage_type:
				enum_damage_type.BLEED:
					execute_bleeding(target)
				enum_damage_type.POI:
					execute_poisoned(target)
			if skill_duration == 1:
				if target.bleed_dots.has(self):
					target.bleed_dots.erase(self)
				if target.poison_dots.has(self):
					target.poison_dots.erase(self)
			ConsoleLog.DEBUG("dot_duration: " + str(skill_duration))
	else :
		match damage_type:
			enum_damage_type.BLEED:
				apply_bleed(caster, target)
			enum_damage_type.POI:
				apply_poison(caster, target)

func apply_bleed(caster : unit, target : unit):
	var caster_bleed_chance : float = caster.active_stats.get("bleed_chance")
	var target_bleed_res : float = target.active_stats.get("bleed_res")
	
	if base_accuracy + caster_bleed_chance > target_bleed_res + roll_d_hundred():
		target.bleed_dots.append(self)
		ConsoleLog.DEBUG("bleed applied")
	else:
		ConsoleLog.DEBUG("bleed resisted")

func apply_poison(caster : unit, target : unit):
	var caster_poi_chance : float = caster.active_stats.get("poi_chance")
	var target_poi_res : float = target.active_stats.get("poi_res")
	
	if base_accuracy + caster_poi_chance > target_poi_res + roll_d_hundred():
		target.poison_dots.append(self)
		ConsoleLog.DEBUG("poison applied")
	else:
		ConsoleLog.DEBUG("poison resisted")

func execute_bleeding(target : unit):
	if target.bleed_dots.has(self):
		var target_bleed_res : float = target.active_stats.get("bleed_res")
		var target_damage_res : float = target.active_stats.get("damage_res")
		var target_max_health : float = target.base_stats.get("health_points")
		
		var premitigated_damage : float = target_max_health / base_value
		var postmitigated_damage : float = premitigated_damage * (100 - target_bleed_res - target_damage_res)/100
		
		target.active_stats.set("health_points",postmitigated_damage)
		ConsoleLog.INFO(["premitigated_damage","postmitigated_damage"],[premitigated_damage,postmitigated_damage])

func execute_poisoned(target : unit):
	if target.poison_dots.has(self):
		var target_poi_res : float = target.active_stats.get("poi_res")
		var target_damage_res : float = target.active_stats.get("damage_res")
		var target_max_health : float = target.base_stats.get("health_points")
		
		var premitigated_damage : float = target_max_health / base_value
		var postmitigated_damage : float = premitigated_damage * (100 - target_poi_res - target_damage_res)/100
		
		target.active_stats.set("health_points",postmitigated_damage)
		ConsoleLog.INFO(["premitigated_damage","postmitigated_damage"],[premitigated_damage,postmitigated_damage])
