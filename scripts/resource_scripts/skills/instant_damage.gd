extends skill_fragment

var consistent_spell_cast : bool = true
var spellcast_hit : bool = false

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, _skill_duration : int):
	if turn_one:
		match damage_type:
			enum_damage_type.PIERCE:
				deal_phys_damage(caster,target,"pierce_res")
			enum_damage_type.SLASH:
				deal_phys_damage(caster,target,"slash_res")
			enum_damage_type.BLUD:
				deal_phys_damage(caster,target,"blud_res")
			enum_damage_type.FIRE:
				deal_magic_damage(caster,target,"fire_affinity","fire_res")
			enum_damage_type.ELEC:
				deal_magic_damage(caster,target,"elec_affinity","elec_res")
			enum_damage_type.ICE:
				deal_magic_damage(caster,target,"ice_affinity","ice_res")
			enum_damage_type.POI:
				deal_magic_damage(caster,target,"poi_affinity","poi_res")

func deal_phys_damage(caster : unit, target : unit, defensive_stat : String):
	var caster_accuracy : float = caster.active_stats.get("accuracy")
	var target_evasion : float = target.active_stats.get("evasion")
	
	var hit_chance = base_accuracy + caster_accuracy - target_evasion
	var hit = roll_d_hundred()
	if hit < hit_chance:
		ConsoleLog.DEBUG("hit")
		add_unit_to_defined_targets(target)
		
		var damage_fork : float = 1 + (hit_chance - hit)/100
		if damage_fork > 1.3:
			damage_fork = 1.3
		
		var caster_atk : float = caster.active_stats.get("phys_atk")
		var target_def : float = target.active_stats.get("phys_def")
		var caster_crit_chance : float = caster.active_stats.get("crit_chance")
		
		var premitigated_damage : float = base_value * (1 + (caster_atk - target_def)/100) * damage_fork
		if premitigated_damage < 2:
			premitigated_damage = 2
		
		var crit_chance : float = base_crit_chance + caster_crit_chance
		var is_crit : bool = false
		var postmitigated_damage : float = 0
		if roll_d_hundred() <= crit_chance:
			is_crit = true
			postmitigated_damage = premitigated_damage
			ConsoleLog.DEBUG("critical hit")
		else:
			var target_type_res : float = target.active_stats.get(defensive_stat)
			var target_damage_res : float = target.active_stats.get("damage_res")
			
			postmitigated_damage = premitigated_damage * (100 - target_type_res - target_damage_res)/100
		
		var postmitigated_elemental_damage : float = apply_onhit_damage(caster,target,damage_fork,is_crit)
		
		# activate block stance
		EventBus.emit_signal_with_log(EventBus.block_stance_triggered,[[postmitigated_damage,postmitigated_elemental_damage]])
		
		var target_current_health_points : float = target.active_stats.get("health_points")
		var remaining_target_health : int = roundi(target_current_health_points - postmitigated_damage - postmitigated_elemental_damage)
		target.active_stats.set("health_points",remaining_target_health)
		
		# activate retaliation stance
		EventBus.emit_signal_with_log(EventBus.retaliate_stance_triggered,[caster,target])
		
		ConsoleLog.INFO(["hit_chance","hit","damage_fork","crit_chance","premitigated_damage","postmitigated_damage","elemental_damage","remaining_health"],
		[hit_chance,hit,damage_fork,crit_chance,premitigated_damage,postmitigated_damage,postmitigated_elemental_damage,remaining_target_health])
	else:
		ConsoleLog.DEBUG("missed")
	
	# activate chase stance
	EventBus.emit_signal_with_log(EventBus.chase_stance_triggered,[caster,target])

func apply_onhit_damage(caster : unit, target : unit, damage_fork : float, is_critical : bool) -> float:
	
	var total_elemental_damage : float = 0
	
	var fire_atk : float = caster.active_stats.get("fire_atk")
	var elec_atk : float = caster.active_stats.get("elec_atk")
	var ice_atk : float = caster.active_stats.get("ice_atk")
	
	total_elemental_damage = calculate_magic_onhit_damage(fire_atk,target,"fire_res",damage_fork,is_critical)
	total_elemental_damage = total_elemental_damage + calculate_magic_onhit_damage(elec_atk,target,"elec_res",damage_fork,is_critical)
	total_elemental_damage = total_elemental_damage + calculate_magic_onhit_damage(ice_atk,target,"ice_res",damage_fork,is_critical)
	
	return total_elemental_damage

func calculate_magic_onhit_damage(elemental_atk : float, target : unit, elemental_res : String, damage_fork : float, is_critical: bool) -> float:
	if elemental_atk > 0:
		var premitigated_elemental_damage : float = elemental_atk * damage_fork
		var postmitigated_elemental_damage : float = 0
		
		if is_critical:
			postmitigated_elemental_damage = premitigated_elemental_damage
		else:
			var target_elemental_res : float = target.active_stats.get(elemental_res)
			var target_damage_res : float = target.active_stats.get("damage_res")
			postmitigated_elemental_damage = premitigated_elemental_damage * (100 - target_elemental_res - target_damage_res)/100
		
		return postmitigated_elemental_damage
	else:
		return 0

func deal_magic_damage(caster : unit, target : unit, magic_affinity : String, defensive_stat : String):
	ConsoleLog.DEBUG("consistent_spell_cast bool: " + str(consistent_spell_cast))
	var caster_affinity : float = caster.active_stats.get(magic_affinity)
	
	if consistent_spell_cast:
		var spell_hit : float = roll_d_hundred() + base_accuracy
		if spell_hit < caster_affinity:
			spellcast_hit = true
		consistent_spell_cast = false
		ConsoleLog.DEBUG("spellcast_hit: " + str(spellcast_hit))
	
	if spellcast_hit:
		add_unit_to_defined_targets(target)
		
		var caster_atk : float = caster.active_stats.get("magic_atk")
		var target_def : float = target.active_stats.get("magic_def")
		var target_type_res : float = target.active_stats.get(defensive_stat)
		var target_damage_res : float = target.active_stats.get("damage_res")
		
		var premitigated_damage : float = base_value * (1 + (caster_atk - target_def)/100) # * winds
		if premitigated_damage < 2:
			premitigated_damage = 2
		
		var postmitigated_damage : float = premitigated_damage * (100 - target_type_res - target_damage_res)/100
		
		var target_current_health : float = target.active_stats.get("health_points")
		var remaining_target_health : float = target_current_health - postmitigated_damage
		
		target.active_stats.set("health_points", remaining_target_health)
		
		ConsoleLog.INFO(["premitigated_damage","postmitigated_damage","remaining_target_health"],[premitigated_damage,postmitigated_damage,remaining_target_health])
