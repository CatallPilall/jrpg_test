extends skill_fragment

func execute_skill_fragment(_caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if turn_one:
		match buff_type:
			enum_buff_type.WEAPON:
				if first_buff:
					cleanse_buff(target, target.weapon_buff)
				filter_buff_stats(target,false,1)
			enum_buff_type.BODY:
				if first_buff:
					cleanse_buff(target, target.body_buff)
				filter_buff_stats(target,false,1)
			enum_buff_type.AURA:
				if first_buff:
					cleanse_buff(target, target.aura_buff)
				filter_buff_stats(target,false,1)
			enum_buff_type.BLESSING:
				if first_buff:
					cleanse_buff(target, target.blessing)
				filter_buff_stats(target,false,1)
			enum_buff_type.STANCE:
				if first_buff:
					cleanse_buff(target, target.stance)
				filter_buff_stats(target,false,1)
			enum_buff_type.CURSE:
				filter_buff_stats(target,true,1)
	if skill_duration == 0:
		match buff_type:
			enum_buff_type.CURSE:
				for curse : skill_fragment in target.curses:
					if curse == self:
						curse.reverse_buff(target)
						target.curses.erase(curse)
						return
			enum_buff_type.WEAPON:
				cleanse_buff(target,target.weapon_buff)
			enum_buff_type.BODY:
				cleanse_buff(target, target.body_buff)
			enum_buff_type.AURA:
				cleanse_buff(target, target.aura_buff)
			enum_buff_type.STANCE:
				cleanse_buff(target,target.stance)
			enum_buff_type.BLESSING:
				cleanse_buff(target, target.blessing)

func filter_buff_stats(target : unit, is_curse : bool, reversing : int):
	match stat_buff:
		enum_stat_buff.SPEED:
			hit_debuff(target, "speed", is_curse, reversing)
		enum_stat_buff.STATUS_DEF:
			hit_debuff(target, "status_def", is_curse, reversing)
		enum_stat_buff.PHYS_ATK:
			hit_debuff(target, "phys_atk", is_curse, reversing)
		enum_stat_buff.PHYS_DEF:
			hit_debuff(target, "phys_def", is_curse, reversing)
		enum_stat_buff.PIERCE_DEF:
			hit_debuff(target, "pierce_def", is_curse, reversing)
		enum_stat_buff.SLASH_DEF:
			hit_debuff(target, "slash_def", is_curse, reversing)
		enum_stat_buff.BLUD_DEF:
			hit_debuff(target, "blud_def", is_curse, reversing)
		enum_stat_buff.ACCURACY:
			hit_debuff(target, "accuracy", is_curse, reversing)
		enum_stat_buff.EVASION:
			hit_debuff(target, "evasion", is_curse, reversing)
		enum_stat_buff.CRIT_CHANCE:
			hit_debuff(target, "crit_chance", is_curse, reversing)
		enum_stat_buff.CRIT_EFFICIENCY:
			hit_debuff(target, "crit_efficiency", is_curse, reversing)
		enum_stat_buff.STATUS_DAMAGE:
			hit_debuff(target, "status_damage", is_curse, reversing)
		enum_stat_buff.MAGIC_ATK:
			hit_debuff(target, "magic_atk", is_curse, reversing)
		enum_stat_buff.MAGIC_DEF:
			hit_debuff(target, "magic_def", is_curse, reversing)
		enum_stat_buff.FIRE_DEF:
			hit_debuff(target, "fire_def", is_curse, reversing)
		enum_stat_buff.ELEC_DEF:
			hit_debuff(target, "elec_def", is_curse, reversing)
		enum_stat_buff.ICE_DEF:
			hit_debuff(target, "ice_def", is_curse, reversing)
		enum_stat_buff.FIRE_EFFICIENCY:
			hit_debuff(target, "fire_efficiency", is_curse, reversing)
		enum_stat_buff.ELEC_EFFICIENCY:
			hit_debuff(target, "elec_efficiency", is_curse, reversing)
		enum_stat_buff.ICE_EFFICIENCY:
			hit_debuff(target, "ice_efficiency", is_curse, reversing)
		enum_stat_buff.BACKFIRE_CHANCE:
			hit_debuff(target, "backfire_chance", is_curse, reversing)
		enum_stat_buff.POOF_CHANCE:
			hit_debuff(target, "poof_chance", is_curse, reversing)
		enum_stat_buff.OVERCAST_CHANCE:
			hit_debuff(target, "overcast_chance", is_curse, reversing)
		enum_stat_buff.POI_DEF:
			hit_debuff(target, "poi_def", is_curse, reversing)
		enum_stat_buff.POI_EFFICIENCY:
			hit_debuff(target, "poi_efficiency", is_curse, reversing)
		enum_stat_buff.LUCKY_CHANCE:
			hit_debuff(target, "lucky_chance", is_curse, reversing)

func hit_debuff(target : unit, buff_stat : String, is_curse : bool, reversing : int):
	if is_curse:
		var cast = target.active_stats.get("status_def") + roll_d_hundred()
		if cast < base_accuracy:
			apply_buff_debuff(target, buff_stat, reversing)
		else:
			ConsoleLog.DEBUG(self," debuff missed")
	else:
		apply_buff_debuff(target, buff_stat, reversing)

func apply_buff_debuff(target : unit, buff_stat : String, reversing : int):
	
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
	
	var resulting_buff = (base_value + target.base_stats.get(get_scaling_stat()) * stat_scaling) * reversing
	var updated_target_stat = target.active_stats.get(buff_stat) + resulting_buff
	target.active_stats.set(buff_stat, updated_target_stat)
	ConsoleLog.INFO(self,["resulting_buff","updated_target_stats"],[resulting_buff,updated_target_stat])

func reverse_buff(target : unit):
	filter_buff_stats(target,false,-1)
	ConsoleLog.DEBUG(self, " reverse_buff called")
