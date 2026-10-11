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
	NONE,PHYS_ATK,PHYS_DEF,MAGIC_ATK,MAGIC_DEF,SPEED,ACCURACY,EVASION,CRIT_CHANCE,
	PIERCE_RES,SLASH_RES,BLUD_RES,FIRE_RES,ELEC_RES,ICE_RES,DAMAGE_RES,
	CC_CHANCE,CC_RES,CURSE_CHANCE,CURSE_RES,BLEED_CHANCE,BLEED_RES,POI_CHANCE,POI_RES,
	BUFF_STRENGTH,HEALING_STRENGTH,LUCKY_CHANCE,
	FIRE_ATK,ELEC_ATK,ICE_ATK,FIRE_AFFINITY,ELEC_AFFINITY,ICE_AFFINITY,POI_AFFINITY}
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
		enum_stat_buff.PHYS_ATK:
			return "phys_atk"
		enum_stat_buff.PHYS_DEF:
			return "phys_def"
		enum_stat_buff.MAGIC_ATK:
			return "magic_atk"
		enum_stat_buff.MAGIC_DEF:
			return "magic_def"
		enum_stat_buff.SPEED:
			return "speed"
		enum_stat_buff.ACCURACY:
			return "accuracy"
		enum_stat_buff.EVASION:
			return "evasion"
		enum_stat_buff.CRIT_CHANCE:
			return "crit_chance"
		
		enum_stat_buff.PIERCE_RES:
			return "pierce_res"
		enum_stat_buff.SLASH_RES:
			return "slash_res"
		enum_stat_buff.BLUD_RES:
			return "blud_res"
		enum_stat_buff.FIRE_RES:
			return "fire_res"
		enum_stat_buff.ELEC_RES:
			return "elec_res"
		enum_stat_buff.ICE_RES:
			return "ice_res"
		enum_stat_buff.DAMAGE_RES:
			return "damage_res"
		
		enum_stat_buff.CC_CHANCE:
			return "cc_chance"
		enum_stat_buff.CC_RES:
			return "cc_res"
		enum_stat_buff.CURSE_CHANCE:
			return "curse_chance"
		enum_stat_buff.CURSE_RES:
			return "curse_res"
		enum_stat_buff.BLEED_CHANCE:
			return "bleed_chance"
		enum_stat_buff.BLEED_RES:
			return "bleed_res"
		enum_stat_buff.POI_CHANCE:
			return "poi_chance"
		enum_stat_buff.POI_RES:
			return "poi_res"
		
		enum_stat_buff.BUFF_STRENGTH:
			return "buff_strength"
		enum_stat_buff.HEALING_STRENGTH:
			return "healing_strength"
		enum_stat_buff.LUCKY_CHANCE:
			return "lucky_chance"
		
		enum_stat_buff.FIRE_ATK:
			return "fire_atk"
		enum_stat_buff.ELEC_ATK:
			return "elec_atk"
		enum_stat_buff.ICE_ATK:
			return "ice_atk"
		enum_stat_buff.FIRE_AFFINITY:
			return "fire_affinity"
		enum_stat_buff.ELEC_AFFINITY:
			return "elec_affinity"
		enum_stat_buff.ICE_AFFINITY:
			return "ice_affinity"
		enum_stat_buff.POI_AFFINITY:
			return "poi_affinity"
	return ""
