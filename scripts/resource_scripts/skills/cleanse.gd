extends skill_fragment

func execute_skill_fragment(_caster : unit, target : unit, turn_one : bool, _skill_duration : int):
	if turn_one:
		match buff_type:
			enum_buff_type.WEAPON:
				cleanse_buff(target,target.weapon_buff)
			enum_buff_type.BODY:
				cleanse_buff(target,target.body_buff)
			enum_buff_type.AURA:
				cleanse_buff(target,target.aura_buff)
			enum_buff_type.BLESSING:
				cleanse_buff(target,target.blessing)
			enum_buff_type.STANCE:
				cleanse_buff(target,target.stance)
			enum_buff_type.CURSE:
				cleanse_buff(target,target.curses)
		
		match crowd_control_type:
			enum_crowd_control_type.DISARM:
				target.disarm.clear()
			enum_crowd_control_type.SILENCE:
				target.silence.clear()
			enum_crowd_control_type.ROOT:
				target.root.clear()
			enum_crowd_control_type.SLEEP:
				target.sleep.clear()
			enum_crowd_control_type.STUN:
				target.stun.clear()
			enum_crowd_control_type.PARALYZE:
				target.paralyze.clear()
		
		match damage_type:
			enum_damage_type.BLEED:
				target.bleed_dots.clear()
			enum_damage_type.POI:
				target.poison_dots.clear()

func reverse_buff(_target : unit):
	pass
