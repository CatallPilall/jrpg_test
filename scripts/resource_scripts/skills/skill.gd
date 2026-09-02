extends Resource

class_name skill

var is_combat_turn_ended_connected : bool = false

var caster : unit
var primary_targets : Array[unit]
var secondary_targets : Array[unit]

enum enum_skill_targeting{NONE,SELF,SINGLE_ENEMY,TEAM_ENEMY}
@export var primary_skill_targeting : enum_skill_targeting
@export var secondary_skill_targeting : enum_skill_targeting

enum enum_skill_type{ATTACK,SPELL,ITEM}
@export var skill_type : enum_skill_type

@export var skill_speed : int
@export var skill_duration : int

@export var first_skill_fragment : skill_fragment

var turn_one : bool = true
var total_speed : int

func set_caster_and_targets(new_caster : unit, new_targets : Array[unit]):
	caster = new_caster
	primary_targets = new_targets
	total_speed = skill_speed + caster.active_stats.get("speed")

func execute_skill():
	first_skill_fragment.iterate_through_skill_fragments(caster,primary_targets,secondary_targets,turn_one)
	
	turn_one = false
	
	if skill_duration == 0:
		prepare_skill_for_deletion()
	else:
		skill_duration -= skill_duration

func prepare_skill_for_deletion():
	first_skill_fragment = null
	primary_targets.clear()
	secondary_targets.clear()
	caster = null
	connect_to_combat_turn_ended()

func connect_to_combat_turn_ended():
	if not is_combat_turn_ended_connected:
		is_combat_turn_ended_connected = true
		EventBus.combat_turn_ended.connect(_combat_turn_ended)
		ConsoleLog.SIGNAL(self,"combat_turn_ended","connected",1)

func disconnect_from_combat_turn_ended():
	if is_combat_turn_ended_connected:
		is_combat_turn_ended_connected = false
		EventBus.combat_turn_ended.disconnect(_combat_turn_ended)
		ConsoleLog.SIGNAL(self,"combat_turn_ended","disconnected",0)

func _combat_turn_ended(signal_key : int):
	disconnect_from_combat_turn_ended()
	
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"clean_up_skill","emit",new_signal_key)
	EventBus.clean_up_skill.emit(self,new_signal_key)
	
	ConsoleLog.SIGNAL(self,"combat_turn_ended","processed",signal_key)
