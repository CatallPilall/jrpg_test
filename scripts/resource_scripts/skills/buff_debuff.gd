extends skill_fragment

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if turn_one:
		match buff_type:
			enum_buff_type.WEAPON:
				if first_buff:
					undo_buff(caster, target, target.weapon_buff)
				filter_buff_stats(caster,target,false,1)
			enum_buff_type.BODY:
				if first_buff:
					undo_buff(caster, target, target.body_buff)
				filter_buff_stats(caster,target,false,1)
			enum_buff_type.AURA:
				if first_buff:
					undo_buff(caster, target, target.aura_buff)
				filter_buff_stats(caster,target,false,1)
			enum_buff_type.BLESSING:
				if first_buff:
					undo_buff(caster, target, target.blessing)
				filter_buff_stats(caster,target,false,1)
			enum_buff_type.STANCE:
				if first_buff:
					undo_buff(caster, target, target.stance)
				filter_buff_stats(caster,target,false,1)
			enum_buff_type.CURSE:
				filter_buff_stats(caster,target,true,1)
	if skill_duration == 0:
		match buff_type:
			enum_buff_type.CURSE:
				for curse : skill_fragment in target.curses:
					if curse == self:
						curse.reverse_buff(caster,target)
						target.curses.erase(curse)
						return
			enum_buff_type.WEAPON:
				undo_buff(caster, target,target.weapon_buff)
			enum_buff_type.BODY:
				undo_buff(caster, target, target.body_buff)
			enum_buff_type.AURA:
				undo_buff(caster, target, target.aura_buff)
			enum_buff_type.STANCE:
				undo_buff(caster, target,target.stance)
			enum_buff_type.BLESSING:
				undo_buff(caster, target, target.blessing)

func filter_buff_stats(caster : unit, target : unit, is_curse : bool, reversing : int):
	match stat_buff:
		enum_stat_buff.PHYS_ATK:
			hit_debuff(caster, target, "phys_atk", is_curse, reversing)
		enum_stat_buff.PHYS_DEF:
			hit_debuff(caster, target, "phys_def", is_curse, reversing)
		enum_stat_buff.MAGIC_ATK:
			hit_debuff(caster, target, "magic_atk", is_curse, reversing)
		enum_stat_buff.MAGIC_DEF:
			hit_debuff(caster, target, "magic_def", is_curse, reversing)
		enum_stat_buff.SPEED:
			hit_debuff(caster, target, "speed", is_curse, reversing)
		enum_stat_buff.ACCURACY:
			hit_debuff(caster, target, "accuracy", is_curse, reversing)
		enum_stat_buff.EVASION:
			hit_debuff(caster, target, "evasion", is_curse, reversing)
		enum_stat_buff.CRIT_CHANCE:
			hit_debuff(caster, target, "crit_chance", is_curse, reversing)
		
		enum_stat_buff.PIERCE_RES:
			hit_debuff(caster, target, "pierce_res", is_curse, reversing)
		enum_stat_buff.SLASH_RES:
			hit_debuff(caster, target, "slash_res", is_curse, reversing)
		enum_stat_buff.BLUD_RES:
			hit_debuff(caster, target, "blud_res", is_curse, reversing)
		enum_stat_buff.FIRE_RES:
			hit_debuff(caster, target, "fire_res", is_curse, reversing)
		enum_stat_buff.ELEC_RES:
			hit_debuff(caster, target, "elec_res", is_curse, reversing)
		enum_stat_buff.ICE_RES:
			hit_debuff(caster, target, "ice_res", is_curse, reversing)
		enum_stat_buff.DAMAGE_RES:
			hit_debuff(caster, target, "damage_res", is_curse, reversing)
		
		enum_stat_buff.CC_CHANCE:
			hit_debuff(caster, target, "cc_chance", is_curse, reversing)
		enum_stat_buff.CC_RES:
			hit_debuff(caster, target, "cc_res", is_curse, reversing)
		enum_stat_buff.CURSE_CHANCE:
			hit_debuff(caster, target, "curse_chance", is_curse, reversing)
		enum_stat_buff.CURSE_RES:
			hit_debuff(caster, target, "curse_res", is_curse, reversing)
		enum_stat_buff.BLEED_CHANCE:
			hit_debuff(caster, target, "bleed_chance", is_curse, reversing)
		enum_stat_buff.BLEED_RES:
			hit_debuff(caster, target, "bleed_res", is_curse, reversing)
		enum_stat_buff.POI_CHANCE:
			hit_debuff(caster, target, "poi_chance", is_curse, reversing)
		enum_stat_buff.POI_RES:
			hit_debuff(caster, target, "poi_res", is_curse, reversing)
		
		enum_stat_buff.BUFF_STRENGTH:
			hit_debuff(caster, target, "buff_strength", is_curse, reversing)
		enum_stat_buff.HEALING_STRENGTH:
			hit_debuff(caster, target, "healing_strength", is_curse, reversing)
		enum_stat_buff.LUCKY_CHANCE:
			hit_debuff(caster, target, "lucky_chance", is_curse, reversing)
		
		enum_stat_buff.FIRE_ATK:
			hit_debuff(caster, target, "fire_atk", is_curse, reversing)
		enum_stat_buff.ELEC_ATK:
			hit_debuff(caster, target, "elec_atk", is_curse, reversing)
		enum_stat_buff.ICE_ATK:
			hit_debuff(caster, target, "ice_atk", is_curse, reversing)
		enum_stat_buff.FIRE_AFFINITY:
			hit_debuff(caster, target, "fire_affinity", is_curse, reversing)
		enum_stat_buff.ELEC_AFFINITY:
			hit_debuff(caster, target, "elec_affinity", is_curse, reversing)
		enum_stat_buff.ICE_AFFINITY:
			hit_debuff(caster, target, "ice_affinity", is_curse, reversing)
		enum_stat_buff.POI_AFFINITY:
			hit_debuff(caster, target, "poi_affinity", is_curse, reversing)

func hit_debuff(caster : unit ,target : unit, buff_stat : String, is_curse : bool, reversing : int):
	var buff_power : float = caster.active_stats.get("buff_strength")
	if is_curse:
		var caster_curse_chance : float = caster.active_stats.get("curse_chance")
		var target_curse_res : float = caster.active_stats.get("curse_res")
		
		if base_accuracy + caster_curse_chance > target_curse_res + roll_d_hundred():
			apply_buff_debuff(target, buff_stat, reversing, buff_power)
			add_unit_to_defined_targets(target)
		else:
			ConsoleLog.DEBUG("debuff missed")
	else:
		apply_buff_debuff(target, buff_stat, reversing, buff_power)

func apply_buff_debuff(target : unit, buff_stat : String, reversing : int, buff_power : float):
	
	if reversing == 1:
		match buff_type:
			enum_buff_type.CURSE:
				target.curses.append(self)
			enum_buff_type.WEAPON:
				target.weapon_buff.append(self)
			enum_buff_type.BODY:
				target.body_buff.append(self)
			enum_buff_type.AURA:
				target.aura_buff.append(self)
			enum_buff_type.STANCE:
				target.stance.append(self)
			enum_buff_type.BLESSING:
				target.blessing.append(self)
	
	stat_scaling = stat_scaling + buff_power/100
	var resulting_buff = (base_value + target.base_stats.get(get_scaling_stat()) * stat_scaling) * reversing
	var updated_target_stat = target.active_stats.get(buff_stat) + resulting_buff
	target.active_stats.set(buff_stat, updated_target_stat)
	ConsoleLog.INFO(["resulting_buff","updated_target_stats"],[resulting_buff,updated_target_stat])

func undo_buff(caster: unit, target : unit, buff_array : Array[skill_fragment]):
	ConsoleLog.DEBUG("array to cleanse: " + str(buff_array))
	for buff_skill_fragment in buff_array:
		if buff_skill_fragment == self:
			buff_skill_fragment.reverse_buff(caster,target)
			buff_skill_fragment = null

func reverse_buff(caster : unit, target : unit):
	filter_buff_stats(caster,target,false,-1)
	ConsoleLog.DEBUG("reverse_buff called")
