extends Resource

class_name skill

var caster : unit
var primary_targets : Array[unit]
var secondary_targets : Array[unit]

enum enum_skill_targeting{NONE,SELF,SINGLE_ENEMY,TEAM_ENEMY,FRONT_ENEMY,BACK_ENEMY,LEFT_ENEMY,RIGHT_ENEMY,AREA_ENEMY,
SINGLE_ALLY,TEAM_ALLY,FRONT_ALLY,BACK_ALLY,LEFT_ALLY,RIGHT_ALLY,AREA_ALLY}
@export var primary_skill_targeting : enum_skill_targeting
@export var secondary_skill_targeting : enum_skill_targeting

enum enum_skill_type{ATTACK,SPELL,ITEM}
@export var skill_type : enum_skill_type

@export var skill_speed : int
@export var skill_duration : int

@export var first_skill_fragment : skill_fragment

var turn_one : bool = true
var total_speed : int


func set_caster_and_targets(new_caster : unit, new_primary_targets : Array[unit], new_secondary_targets : Array[unit]):
	ConsoleLog.DEBUG(self,"secondary targets delivered to skill: "+ str(new_secondary_targets))
	caster = new_caster
	primary_targets = new_primary_targets
	secondary_targets.assign(new_secondary_targets)
	ConsoleLog.DEBUG(self,"stored targets in skill: " + str(primary_targets) + " " + str(secondary_targets))
	total_speed = skill_speed + caster.active_stats.get("speed")


func execute_skill():
	ConsoleLog.DEBUG(self," execute skill with targets: " + str(primary_targets) + " " + str(secondary_targets))
	first_skill_fragment.iterate_through_skill_fragments(caster,primary_targets,secondary_targets,turn_one,skill_duration)

	turn_one = false
	if skill_duration == 0:
		prepare_skill_for_deletion()
	else:
		skill_duration = skill_duration -1
	ConsoleLog.DEBUG(self, "skill_duration: "+ str(skill_duration))


func prepare_skill_for_deletion():
	first_skill_fragment.clean_up_skill_fragment()
	first_skill_fragment = null
	primary_targets.clear()
	secondary_targets.clear()
	caster = null
	EventBus.connect_function_with_signal(_combat_turn_ended, EventBus.combat_turn_ended)


func _combat_turn_ended(signal_key : int):
	EventBus.disconnect_function_from_signal(_combat_turn_ended, EventBus.combat_turn_ended)

	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"clean_up_skill","emit",new_signal_key)
	EventBus.clean_up_skill.emit(self,new_signal_key)

	ConsoleLog.SIGNAL(self,"combat_turn_ended","processed",signal_key)
