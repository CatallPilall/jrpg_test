@abstract extends Resource

class_name skill_fragment

enum enum_targeting {PRIMARY,SECONDARY}
@export var targeting : enum_targeting

enum enum_damage_type {NONE,PIERCE,SLASH,BLUD,FIRE,ELEC,ICE,POI,BLEED}
@export var damage_type : enum_damage_type

enum enum_stat_buff {
	NONE,SPEED,STATUS_DEF,PHYS_ATK,PHYS_DEF,PIERCE_DEF,SLASH_DEF,BLUD_DEF,
	ACCURACY,EVASION,CRIT_CHANCE,CRIT_EFFICIENCY,STATUS_DAMAGE,
	MAGIC_ATK,MAGIC_DEF,FIRE_DEF,ELEC_DEF,ICE_DEF,FIRE_EFFICIENCY,ELEC_EFFICIENCY,
	ICE_EFFICIENCY,BACKFIRE_CHANCE,POOF_CHANCE,OVERCAST_CHANCE,
	POI_DEF,POI_EFFICIENCY,LUCKY_CHANCE}
@export var stat_buff : enum_stat_buff

@export var base_value : float
@export var stat_scaling : float
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
		if not secondary_target_defining_fragment:
			secondary_defined_targets = secondary_targets
		child_skill_fragment.iterate_through_skill_fragments(caster, primary_defined_targets, secondary_defined_targets, turn_one, skill_duration)

@abstract func execute_skill_fragment(caster : unit, tatget : unit, turn_one : bool, skill_duration : int)

func clean_up_skill_fragment():
	if child_skill_fragment:
		child_skill_fragment.clean_up_skill_fragment()
	
	primary_defined_targets.clear()
	secondary_defined_targets.clear()

func add_unit_to_defined_targets(target : unit):
	if primary_target_defining_fragment:
			primary_defined_targets.append(target)
	if secondary_target_defining_fragment:
		secondary_defined_targets.append(target)

func roll_d_hundred() -> int:
	return randi_range(1,100)
