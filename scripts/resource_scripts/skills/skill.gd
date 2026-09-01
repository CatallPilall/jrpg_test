extends Resource

class_name skill

var caster : unit
var primary_targets : Array[unit]
var secondary_targets : Array[unit]

enum enum_skill_targeting{NONE,SELF,SINGLE_ENEMY,TEAM_ENEMY}
@export var primary_skill_targeting : enum_skill_targeting
@export var secondary_skill_targeting : enum_skill_targeting

enum enum_skill_type{ATTACK,SPELL,ITEM}
@export var skill_type : enum_skill_type

@export var skill_fragments : Array[skill_fragment]

var cast : bool = true

var skill_speed : int
var total_speed : int

func set_caster_and_targets(new_caster : unit, new_targets : Array[unit]):
	caster = new_caster
	primary_targets = new_targets
	total_speed = skill_speed + caster.active_stats.get("speed")

func execute_skill():
	for u : unit in primary_targets:
		for i : skill_fragment in skill_fragments:
			i.execute_skill_fragment(caster,u)
