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

func deal_phys_damage(caster : unit, target : unit, defensive_stat : String):
	var hit_chance = base_accuracy + caster.active_stats.get("accuracy") - target.active_stats.get("evasion")
	var hit = roll_d_hundred()
	if hit < hit_chance:
		ConsoleLog.DEBUG(self,"hit")
		add_unit_to_defined_targets(target)
		
		var damage_fork : float = 1 + (hit_chance - hit)/100
		var resulting_damage : float = ((base_value + caster.active_stats.get(get_scaling_stat()) * stat_scaling)*damage_fork)
		var crit_chance : float = base_crit_chance + caster.active_stats.get("crit_chance")
		if roll_d_hundred() <= crit_chance:
			resulting_damage = resulting_damage + resulting_damage * caster.active_stats.get("crit_efficiency")/100
		
		var negated_damage : float = resulting_damage * (100 - target.active_stats.get("phys_def") + target.active_stats.get(defensive_stat))/100
		var remaining_target_health : int = roundi(target.active_stats.get("health_points") - negated_damage)
		target.active_stats.set("health_points",remaining_target_health)
		ConsoleLog.INFO(self,["hit_chance","hit","damage_fork","crit_chance","resulting_damage","negetade_damage","remaining_health"],
		[hit_chance,hit,damage_fork,crit_chance,resulting_damage,negated_damage,remaining_target_health])
	else:
		ConsoleLog.DEBUG(self,"missed")

func deal_magic_damage(caster : unit, target : unit, magic_efficiency : String, defensive_stat : String):
	ConsoleLog.DEBUG(self," consistent_spell_cast bool: " + str(consistent_spell_cast))
	if consistent_spell_cast:
		spellcast_value = roll_d_hundred() + base_accuracy
		ConsoleLog.DEBUG(self," spellcast_value roll: " + str(spellcast_value))
	var overcast : bool = false
	var caster_efficiency : float = caster.active_stats.get(magic_efficiency)
	
	if spellcast_value > caster_efficiency + caster.active_stats.get("backfire_chance"):
		if consistent_spell_cast:
			var self_damage : float = base_accuracy
			var remaining_caster_health : int = roundi(caster.active_stats.get("health_points") - self_damage)
			caster.active_stats.set("health_points",remaining_caster_health)
			ConsoleLog.DEBUG(self," spell backfired, self damage = "+ str(self_damage))
			consistent_spell_cast = false
		return
	elif spellcast_value > caster_efficiency + caster.active_stats.get("poof_chance"):
		ConsoleLog.DEBUG(self," spell poofed")
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
	ConsoleLog.INFO(self,["consistent_spell_cast","overcast","caster_efficiency","resulting_damage","negated_damage"],
	[spellcast_value,overcast,caster_efficiency,resulting_damage,negated_damage])

func reverse_buff(_target : unit):
	pass
