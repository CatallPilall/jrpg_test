extends skill_fragment

var stance_caster : unit
var stance_target : unit

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if turn_one:
		stance_caster = caster
		stance_target = target
		match stance_type:
			enum_stance_type.BLOCK:
				EventBus.connect_function_with_signal(self, _block_stance_triggered, EventBus.block_stance_triggered)
			enum_stance_type.PARRY:
				EventBus.connect_function_with_signal(self, _parry_stance_triggered, EventBus.parry_stance_triggered)
			enum_stance_type.RETALIATE:
				EventBus.connect_function_with_signal(self, _retaliate_stance_triggered, EventBus.retaliate_stance_triggered)
			enum_stance_type.COUNTERSPELL:
				EventBus.connect_function_with_signal(self, _counterspell_stance_triggered, EventBus.counterspell_stance_triggered)
			enum_stance_type.CHASE:
				EventBus.connect_function_with_signal(self, _chase_stance_triggered, EventBus.chase_stance_triggered)
			enum_stance_type.GUARD:
				EventBus.connect_function_with_signal(self, _guard_stance_triggered, EventBus.guard_stance_triggered)
		caster.stance.append(self)
	
	if skill_duration == 0:
		match stance_type:
			enum_stance_type.BLOCK:
				EventBus.disconnect_function_with_signal(self, _block_stance_triggered, EventBus.block_stance_triggered)
			enum_stance_type.PARRY:
				EventBus.disconnect_function_with_signal(self, _parry_stance_triggered, EventBus.parry_stance_triggered)
			enum_stance_type.RETALIATE:
				EventBus.disconnect_function_with_signal(self, _retaliate_stance_triggered, EventBus.retaliate_stance_triggered)
			enum_stance_type.COUNTERSPELL:
				EventBus.disconnect_function_with_signal(self, _counterspell_stance_triggered, EventBus.counterspell_stance_triggered)
			enum_stance_type.CHASE:
				EventBus.disconnect_function_with_signal(self, _chase_stance_triggered, EventBus.chase_stance_triggered)
			enum_stance_type.GUARD:
				EventBus.disconnect_function_with_signal(self, _guard_stance_triggered, EventBus.guard_stance_triggered)

func check_cc(caster : unit, relevant_cc : skill.enum_skill_type) -> bool:
	var can_act : bool = true
	
	var is_disarmed : bool = caster.disarm.size()
	var is_silenced : bool = caster.silence.size()
	var is_rooted : bool = caster.root.size()
	var is_sleeping : bool = caster.sleep.size()
	var is_stunned : bool = caster.stun.size()
	var is_paralyzed : bool = caster.paralyze.size()
	
	match relevant_cc:
		skill.enum_skill_type.ATTACK:
			if is_disarmed or is_sleeping or is_stunned or is_paralyzed:
				can_act = false
		skill.enum_skill_type.SPELL:
			if is_silenced or is_sleeping or is_stunned or is_paralyzed:
				can_act = false
		skill.enum_skill_type.MANOUVRE:
			if is_rooted or is_sleeping or is_stunned or is_paralyzed:
				can_act = false
		skill.enum_skill_type.SPECIAL:
			if is_paralyzed:
				can_act = false
	
	return can_act

func _block_stance_triggered(target : unit, postmitigated_damage_array : Array[float], signal_key : int):
	if target == stance_target:
		
		if check_cc(stance_caster,skill.enum_skill_type.MANOUVRE):
			
			postmitigated_damage_array[0] = postmitigated_damage_array[0] * 0.5
			postmitigated_damage_array[1] = postmitigated_damage_array[1] * 0.5
			
			base_value = base_value -1
			if base_value < 1:
				EventBus.disconnect_function_from_signal(self,_block_stance_triggered, EventBus.block_stance_triggered)
			
			ConsoleLog.SIGNAL(EventBus.block_stance_triggered,"processed",signal_key)

func _parry_stance_triggered(target : unit, activating_skill : skill, signal_key : int):
	if target == stance_target:
		
		if check_cc(stance_caster, skill.enum_skill_type.ATTACK):
			
			activating_skill.primary_targets.clear()
			activating_skill.secondary_targets.clear()
			
			base_value = base_value -1
			if base_value < 1:
				EventBus.disconnect_function_from_signal(self,_parry_stance_triggered, EventBus.parry_stance_triggered)
			
			ConsoleLog.SIGNAL(EventBus.parry_stance_triggered,"processed",signal_key)

func _retaliate_stance_triggered(caster : unit, target : unit, signal_key : int):
	if target == stance_target:
		
		if check_cc(stance_caster, skill.enum_skill_type.ATTACK):
			
			var class_damage_type : String = ""
			
			match target.unit_class.class_weapon_type:
				game_class.enum_class_weapon_type.SLASH:
					class_damage_type = "slash_res"
				game_class.enum_class_weapon_type.PIERCE:
					class_damage_type = "pierce_res"
				game_class.enum_class_weapon_type.BLUD:
					class_damage_type = "blud_res"
			
			deal_phys_damage(caster,target,class_damage_type)
			
			base_value = base_value -1
			if base_value < 1:
				EventBus.disconnect_function_from_signal(self,_retaliate_stance_triggered, EventBus.retaliate_stance_triggered)
			
			ConsoleLog.SIGNAL(EventBus.retaliate_stance_triggered,"processed",signal_key)

func _counterspell_stance_triggered(caster : unit, activating_skill : skill, signal_key : int):
	if stance_caster.unit_team != caster.unit_team:
		if check_cc(stance_caster, skill.enum_skill_type.SPELL):
			
			activating_skill.primary_targets.clear()
			activating_skill.secondary_targets.clear()
			
			base_value = base_value -1
			if base_value < 1:
				EventBus.disconnect_function_from_signal(self,_counterspell_stance_triggered, EventBus.counterspell_stance_triggered)
			
			ConsoleLog.SIGNAL(EventBus.counterspell_stance_triggered,"processed",signal_key)

func _chase_stance_triggered(caster : unit, target : unit, signal_key : int):
	if caster == stance_target:
		if check_cc(stance_caster,skill.enum_skill_type.ATTACK):
			
			var class_damage_type : String = ""
			
			match target.unit_class.class_weapon_type:
				game_class.enum_class_weapon_type.SLASH:
					class_damage_type = "slash_res"
				game_class.enum_class_weapon_type.PIERCE:
					class_damage_type = "pierce_res"
				game_class.enum_class_weapon_type.BLUD:
					class_damage_type = "blud_res"
			
			deal_phys_damage(stance_caster,target,class_damage_type)
			
			base_value = base_value -1
			if base_value < 1:
				EventBus.disconnect_function_from_signal(self,_retaliate_stance_triggered, EventBus.retaliate_stance_triggered)
			
			ConsoleLog.SIGNAL(EventBus.chase_stance_triggered,"processed",signal_key)

func _guard_stance_triggered(all_targets : Array[unit],signal_key : int):
	if all_targets.has(stance_target):
		if not all_targets.has(stance_caster):
			if check_cc(stance_caster,skill.enum_skill_type.MANOUVRE):
				all_targets.erase(stance_target)
				all_targets.append(stance_caster)
				
				base_value = base_value -1
				if base_value < 1:
					EventBus.disconnect_function_from_signal(self,_guard_stance_triggered, EventBus.guard_stance_triggered)
				
				ConsoleLog.SIGNAL(EventBus.guard_stance_triggered,"processed",signal_key)

func deal_phys_damage(caster : unit, target : unit, defensive_stat : String):
	var caster_accuracy : float = caster.active_stats.get("accuracy")
	var target_evasion : float = target.active_stats.get("evasion")
	
	var hit_chance = base_accuracy + caster_accuracy - target_evasion
	var hit = roll_d_hundred()
	if hit < hit_chance:
		ConsoleLog.DEBUG("hit")
		
		var damage_fork : float = 1 + (hit_chance - hit)/100
		if damage_fork > 1.3:
			damage_fork = 1.3
		
		var caster_atk : float = caster.active_stats.get("phys_atk")
		var target_def : float = target.active_stats.get("phys_def")
		var caster_crit_chance : float = caster.active_stats.get("crit_chance")
		
		var caster_scaling : float = caster.active_stats.get(get_scaling_stat(true)) * caster_scaling_stat
		var target_scaling : float = caster.active_stats.get(get_scaling_stat(false)) * target_stat_scaling
		
		var premitigated_damage : float = (caster_scaling + target_scaling) * (1 + (caster_atk - target_def)/100) * damage_fork
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
		
		
		var target_current_health_points : float = target.active_stats.get("health_points")
		var remaining_target_health : int = roundi(target_current_health_points - postmitigated_damage - postmitigated_elemental_damage)
		target.active_stats.set("health_points",remaining_target_health)
		
		ConsoleLog.INFO(["hit_chance","hit","damage_fork","crit_chance","premitigated_damage","postmitigated_damage","elemental_damage","remaining_health"],
		[hit_chance,hit,damage_fork,crit_chance,premitigated_damage,postmitigated_damage,postmitigated_elemental_damage,remaining_target_health])
	else:
		ConsoleLog.DEBUG("missed")

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

func reverse_buff(_caster : unit, _target : unit):
	match stance_type:
		enum_stance_type.BLOCK:
			EventBus.disconnect_function_with_signal(self, _block_stance_triggered, EventBus.block_stance_triggered)
		enum_stance_type.PARRY:
			EventBus.disconnect_function_with_signal(self, _parry_stance_triggered, EventBus.parry_stance_triggered)
		enum_stance_type.RETALIATE:
			EventBus.disconnect_function_with_signal(self, _retaliate_stance_triggered, EventBus.retaliate_stance_triggered)
		enum_stance_type.COUNTERSPELL:
			EventBus.disconnect_function_with_signal(self, _counterspell_stance_triggered, EventBus.counterspell_stance_triggered)
		enum_stance_type.CHASE:
			EventBus.disconnect_function_with_signal(self, _chase_stance_triggered, EventBus.chase_stance_triggered)
		enum_stance_type.GUARD:
			EventBus.disconnect_function_with_signal(self, _guard_stance_triggered, EventBus.guard_stance_triggered)
