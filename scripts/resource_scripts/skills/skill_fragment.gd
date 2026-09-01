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
	POI_DEF,POI_EFFICIENCY,LUCKY_ACTION_CHANCE}
@export var stat_buff : enum_stat_buff

@export var base_value : float
@export var stat_scaling : float
@export var base_crit_chance : float
@export var base_accuracy : float

@export var duration : int

@abstract func execute_skill_fragment(caster : unit, target : unit)
