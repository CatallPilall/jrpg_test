extends skill_fragment

func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int):
	if turn_one:
		match crowd_control_type:
			enum_crowd_control_type.DISARM:
				if apply_crowd_control(caster,target):
					target.disarm.append(self)
			enum_crowd_control_type.SILENCE:
				if apply_crowd_control(caster,target):
					target.silence.append(self)
			enum_crowd_control_type.ROOT:
				if apply_crowd_control(caster,target):
					target.root.append(self)
			enum_crowd_control_type.SLEEP:
				if apply_crowd_control(caster,target):
					target.sleep.append(self)
			enum_crowd_control_type.STUN:
				if apply_crowd_control(caster,target):
					target.stun.append(self)
			enum_crowd_control_type.PARALYZE:
				if apply_crowd_control(caster,target):
					target.paralyze.append(self)
	if skill_duration == 0:
		match crowd_control_type:
			enum_crowd_control_type.DISARM:
				if target.disarm.has(self):
					target.disarm.erase(self)
					reverse_buff(target)
			enum_crowd_control_type.SILENCE:
				if target.silence.has(self):
					target.silence.erase(self)
					reverse_buff(target)
			enum_crowd_control_type.ROOT:
				if target.root.has(self):
					target.root.erase(self)
					reverse_buff(target)
			enum_crowd_control_type.SLEEP:
				if target.sleep.has(self):
					target.sleep.erase(self)
					reverse_buff(target)
			enum_crowd_control_type.STUN:
				if target.stun.has(self):
					target.stun.erase(self)
					reverse_buff(target)
			enum_crowd_control_type.PARALYZE:
				if target.paralyze.has(self):
					target.paralyze.erase(self)
					reverse_buff(target)

func apply_crowd_control(caster : unit, target : unit) -> bool:
	var caster_cc_chance : float = caster.active_stats.get("cc_chance")
	var target_cc_res : float = target.active_stats.get("cc_res")
	
	if base_accuracy + caster_cc_chance > target_cc_res + roll_d_hundred():
		target.active_stats.set("cc_res", target_cc_res + base_value)
		return true
	else:
		return false


func reverse_buff(target : unit):
	var target_cc_res : float = target.active_stats.get("cc_res")
	target.active_stats.set("cc_res", target_cc_res - base_value)
