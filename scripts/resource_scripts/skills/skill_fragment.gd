@abstract extends Resource

class_name skill_fragment

enum enum_targeting {PRIMARY,SECONDARY}
@export var targeting : enum_targeting

enum enum_damage_type {NONE,PIERCE,SLASH,BLUD,FIRE,ELEC,ICE,POI,BLEED}
@export var damage_type : enum_damage_type

enum enum_crowd_control_type {NONE,DISARM,SILENCE,ROOT,SLEEP,STUN,PARALYZE}
@export var crowd_control_type : enum_crowd_control_type

enum enum_buff_type {NONE,WEAPON,BODY,AURA,BLESSING,STANCE,CURSE}
@export var buff_type : enum_buff_type

enum enum_stat_buff {
	NONE,SPEED,STATUS_DEF,PHYS_ATK,PHYS_DEF,PIERCE_DEF,SLASH_DEF,BLUD_DEF,
	ACCURACY,EVASION,CRIT_CHANCE,CRIT_EFFICIENCY,STATUS_DAMAGE,
	MAGIC_ATK,MAGIC_DEF,FIRE_DEF,ELEC_DEF,ICE_DEF,FIRE_EFFICIENCY,ELEC_EFFICIENCY,
	ICE_EFFICIENCY,BACKFIRE_CHANCE,POOF_CHANCE,OVERCAST_CHANCE,
	POI_DEF,POI_EFFICIENCY,LUCKY_CHANCE,FIRE_ATK,ELEC_ATK,ICE_ATK,CURSE_EFFICIENCY,
	BUFF_EFFICIENCY,HEALING_EFFICIENCY,RESILIENCE}
@export var stat_buff : enum_stat_buff

enum enum_stance_type {NONE,BLOCK,PARRY,RETALIATE,COUNTERSPELL,CHASE,GUARD}
@export var stance_type : enum_stance_type

@export var first_buff : bool

@export var base_value : float
@export var stat_scaling : float
@export var scaling_stat : enum_stat_buff
@export var base_crit_chance : float
@export var base_accuracy : float

@export var primary_target_defining_fragment : bool
var primary_defined_targets : Array[unit]

@export var secondary_target_defining_fragment : bool
var secondary_defined_targets : Array[unit]

@export var child_skill_fragment : skill_fragment

func iterate_through_skill_fragments(caster : unit, primary_targets : Array[unit], secondary_targets : Array[unit], turn_one : bool, skill_duration : int):
	var relevant_targets : Array[unit]

	if targeting == enum_targeting.PRIMARY:
		relevant_targets = primary_targets
	else:
		relevant_targets = secondary_targets

	for target in relevant_targets:
		execute_skill_fragment(caster, target, turn_one, skill_duration)

	if child_skill_fragment:
		if not primary_target_defining_fragment:
			primary_defined_targets = primary_targets
		if secondary_target_defining_fragment:
			if primary_defined_targets.is_empty():
				secondary_defined_targets.clear()
			else:
				secondary_defined_targets = secondary_targets
		else:
			secondary_defined_targets = secondary_targets
		child_skill_fragment.iterate_through_skill_fragments(caster, primary_defined_targets, secondary_defined_targets, turn_one, skill_duration)

@abstract func execute_skill_fragment(caster : unit, target : unit, turn_one : bool, skill_duration : int)

func clean_up_skill_fragment():
	if child_skill_fragment:
		child_skill_fragment.clean_up_skill_fragment()

	primary_defined_targets.clear()
	secondary_defined_targets.clear()

func add_unit_to_defined_targets(target : unit):
	if primary_target_defining_fragment:
		primary_defined_targets.append(target)

func roll_d_hundred() -> int:
	return randi_range(1,100)

func get_scaling_stat() -> String:
	match scaling_stat:
		enum_stat_buff.SPEED:
			return "speed"
		enum_stat_buff.STATUS_DEF:
			return "status_def"
		enum_stat_buff.PHYS_ATK:
			return "phys_atk"
		enum_stat_buff.PHYS_DEF:
			return "phys_def"
		enum_stat_buff.PIERCE_DEF:
			return "pierce_def"
		enum_stat_buff.SLASH_DEF:
			return "slash_def"
		enum_stat_buff.BLUD_DEF:
			return "blud_def"
		enum_stat_buff.ACCURACY:
			return "accuracy"
		enum_stat_buff.EVASION:
			return "evasion"
		enum_stat_buff.CRIT_CHANCE:
			return "crit_chance"
		enum_stat_buff.CRIT_EFFICIENCY:
			return "crit_efficiency"
		enum_stat_buff.STATUS_DAMAGE:
			return "status_damage"
		enum_stat_buff.MAGIC_ATK:
			return "magic_atk"
		enum_stat_buff.MAGIC_DEF:
			return "magic_def"
		enum_stat_buff.FIRE_DEF:
			return "fire_def"
		enum_stat_buff.ELEC_DEF:
			return "elec_def"
		enum_stat_buff.ICE_DEF:
			return "ice_def"
		enum_stat_buff.FIRE_EFFICIENCY:
			return "fire_efficiency"
		enum_stat_buff.ELEC_EFFICIENCY:
			return "elec_efficiency"
		enum_stat_buff.ICE_EFFICIENCY:
			return "ice_efficiency"
		enum_stat_buff.BACKFIRE_CHANCE:
			return "backfire_chance"
		enum_stat_buff.POOF_CHANCE:
			return "poof_chance"
		enum_stat_buff.OVERCAST_CHANCE:
			return "overcast_chance"
		enum_stat_buff.POI_DEF:
			return "poi_def"
		enum_stat_buff.POI_EFFICIENCY:
			return "poi_efficiency"
		enum_stat_buff.LUCKY_CHANCE:
			return "lucky_chance"
		enum_stat_buff.FIRE_ATK:
			return "fire_atk"
		enum_stat_buff.ELEC_ATK:
			return "elec_atk"
		enum_stat_buff.ICE_ATK:
			return "ice_atk"
		enum_stat_buff.CURSE_EFFICIENCY:
			return "curse_efficiency"
		enum_stat_buff.BUFF_EFFICIENCY:
			return "buff_efficiency"
		enum_stat_buff.HEALING_EFFICIENCY:
			return "healing_efficiency"
		enum_stat_buff.RESILIENCE:
			return "resilience"
	return ""
