extends skill_fragment

var consistent_spell_cast : bool = true
var spellcast_value : float

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, _skill_duration : int):
	if turn_one:
		match damage_type:
			enum_damage_type.PIERCE:
				deal_phys_damage(caster,target,"pierce_def")
			enum_damage_type.SLASH:
				deal_phys_damage(caster,target,"slash_def")
			enum_damage_type.BLUD:
				deal_phys_damage(caster,target,"blud_def")
			enum_damage_type.FIRE:
				deal_magic_damage(caster,target,"fire_efficiency","fire_def")
			enum_damage_type.ELEC:
				deal_magic_damage(caster,target,"elec_efficiency","elec_def")
			enum_damage_type.ICE:
				deal_magic_damage(caster,target,"ice_efficiency","ice_def")
			enum_damage_type.POI:
				deal_magic_damage(caster,target,"poi_efficiency","poi_def")

func deal_phys_damage(caster : unit, target : unit, defensive_stat : String):
	var hit_chance = base_accuracy + caster.active_stats.get("accuracy") - target.active_stats.get("evasion")
	var hit = roll_d_hundred()
	if hit < hit_chance:
		ConsoleLog.DEBUG("hit")
		add_unit_to_defined_targets(target)
		
		var damage_fork : float = 1 + (hit_chance - hit)/100
		var resulting_damage : float = ((base_value + caster.active_stats.get(get_scaling_stat()) * stat_scaling)*damage_fork)
		var crit_chance : float = base_crit_chance + caster.active_stats.get("crit_chance")
		var is_crit : bool = false
		if roll_d_hundred() <= crit_chance:
			is_crit = true
			resulting_damage = resulting_damage * (1 + caster.active_stats.get("crit_efficiency")/100)
			ConsoleLog.DEBUG("critical hit")
		
		var negated_phys_damage : float = resulting_damage * (100 - target.active_stats.get("phys_def") + target.active_stats.get(defensive_stat))/100
		
		var negated_elemental_damage : float = apply_onhit_damage(caster,target,damage_fork,is_crit)
		
		var remaining_target_health : int = roundi(target.active_stats.get("health_points") - (negated_phys_damage + negated_elemental_damage))
		target.active_stats.set("health_points",remaining_target_health)
		ConsoleLog.INFO(["hit_chance","hit","damage_fork","crit_chance","resulting_damage","negetade_damage","remaining_health"],
		[hit_chance,hit,damage_fork,crit_chance,resulting_damage,negated_phys_damage,remaining_target_health])
	else:
		ConsoleLog.DEBUG("missed")

func apply_onhit_damage(caster : unit, target : unit, damage_fork : float, is_critical : bool) -> float:
	
	var total_elemental_damage : float = 0
	
	var fire_atk : float = caster.active_stats.get("fire_atk")
	var elec_atk : float = caster.active_stats.get("elec_atk")
	var ice_atk : float = caster.active_stats.get("ice_atk")
	
	var crit_efficiency : float = 1 + caster.active_stats.get("crit_efficiency") / 100
	
	if fire_atk:
		var fire_damage : float = fire_atk * damage_fork
		if is_critical:
			fire_damage = fire_damage * crit_efficiency
		
		fire_damage = fire_damage * (100 - target.active_stats.get("fire_def")/100)
		
		total_elemental_damage = total_elemental_damage + fire_damage
	
	if elec_atk:
		var elec_damage : float = elec_atk * damage_fork
		if is_critical:
			elec_damage = elec_damage * crit_efficiency
		
		elec_damage = elec_damage * (100 - target.active_stats.get("elec_def")/100)
		
		total_elemental_damage = total_elemental_damage + elec_damage
	
	if ice_atk:
		var ice_damage : float = ice_atk * damage_fork
		if is_critical:
			ice_damage = ice_damage * crit_efficiency
		
		ice_damage = ice_damage * (100 - target.active_stats.get("ice_def")/100)
		
		total_elemental_damage = total_elemental_damage + ice_damage
	
	return total_elemental_damage

func deal_magic_damage(caster : unit, target : unit, magic_efficiency : String, defensive_stat : String):
	ConsoleLog.DEBUG("consistent_spell_cast bool: " + str(consistent_spell_cast))
	if consistent_spell_cast:
		spellcast_value = roll_d_hundred() + base_accuracy
		ConsoleLog.DEBUG("spellcast_value roll: " + str(spellcast_value))
	var overcast : bool = false
	var caster_efficiency : float = caster.active_stats.get(magic_efficiency)
	
	if spellcast_value > caster_efficiency + caster.active_stats.get("backfire_chance"):
		if consistent_spell_cast:
			var self_damage : float = base_accuracy
			var remaining_caster_health : int = roundi(caster.active_stats.get("health_points") - self_damage)
			caster.active_stats.set("health_points",remaining_caster_health)
			ConsoleLog.DEBUG("spell backfired, self damage = "+ str(self_damage))
			consistent_spell_cast = false
		return
	elif spellcast_value > caster_efficiency + caster.active_stats.get("poof_chance"):
		ConsoleLog.DEBUG("spell poofed")
		consistent_spell_cast = false
		return
	elif spellcast_value < caster_efficiency/base_accuracy + caster.active_stats.get("overcast_chance"):
		overcast = true
	
	consistent_spell_cast = false
	add_unit_to_defined_targets(target)
	var resulting_damage : float = (base_value + caster.active_stats.get(get_scaling_stat()) * stat_scaling) * caster_efficiency / 100
	if overcast:
		resulting_damage = resulting_damage * 1.5
	var negated_damage : float = resulting_damage * (100 - target.active_stats.get(defensive_stat))/100
	var remaining_target_health : int = roundi(target.active_stats.get("health_points") - negated_damage)
	target.active_stats.set("health_points",remaining_target_health)
	ConsoleLog.INFO(["consistent_spell_cast","overcast","caster_efficiency","resulting_damage","negated_damage"],
	[spellcast_value,overcast,caster_efficiency,resulting_damage,negated_damage])
