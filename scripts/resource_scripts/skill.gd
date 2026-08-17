extends Resource

class_name skill

var caster : unit
var targets : Array[unit]

var is_remove_dead_unit_connected : bool = false
var is_combat_turn_ended_connected : bool = false

func connect_to_remove_dead_unit():
	if not is_remove_dead_unit_connected:
		is_remove_dead_unit_connected = true
		EventBus.remove_dead_unit.connect(_remove_dead_unit)
		ConsoleLog.SIGNAL(self,"remove_dead_unit","connected",1)

func disconnect_from_remove_dead_unit():
	if is_remove_dead_unit_connected:
		is_remove_dead_unit_connected = false
		EventBus.remove_dead_unit.disconnect(_remove_dead_unit)
		ConsoleLog.SIGNAL(self,"remove_dead_unit","disconnected",0)

enum enum_skill_targeting{NONE,SELF,SINGLE_ENEMY,TEAM_ENEMY}
@export var skill_targeting : enum_skill_targeting

enum enum_skill_type{ATTACK,SPELL}
@export var skill_type : enum_skill_type

@export var phys_damage : int

@export var fire_damage : int

@export var skill_speed : int

@export var skill_duration : int

var total_speed : int

func set_caster_and_targets(new_caster : unit, new_targets : Array[unit]):
	caster = new_caster
	targets = new_targets
	total_speed = caster.unit_speed + skill_speed
	connect_all_signals()

func connect_all_signals():
	connect_to_remove_dead_unit()

func display_skill_data():
	ConsoleLog.INFO(self,["caster","targets","total_speed","skill_duration"],[caster,targets,total_speed,skill_duration])

func execute_skill():
	if targets.is_empty():
		clean_up_skill()
		return
	for i in targets:
		if phys_damage:
			deal_phys_damage(i)
		if fire_damage:
			deal_fire_damage(i)
		check_lethal(i)
	if skill_duration == 0:
		clean_up_skill()
	else:
		skill_duration -= 1

func deal_phys_damage(my_target : unit):
	var resulting_damage : int = round(float(caster.unit_atk + phys_damage) * (100 - my_target.unit_def)/100)
	my_target.unit_health -= resulting_damage

func deal_fire_damage(my_target : unit):
	var resulting_damage : int = round(float(fire_damage) * (100 - my_target.unit_fire_resist)/100)
	my_target.unit_health -= resulting_damage

func check_lethal(my_target : unit):
	if my_target.unit_health <= 0:
		ConsoleLog.MESSAGE(self,str(my_target) + " is dead")
		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"remove_dead_unit","emit",new_signal_key)
		EventBus.remove_dead_unit.emit(my_target,new_signal_key)

func _remove_dead_unit(dead_unit : unit, signal_key : int):
	if dead_unit == caster:
		clean_up_skill()
		return
	for i in targets:
		if i == dead_unit:
			targets.erase(i)
	ConsoleLog.SIGNAL(self,"remove_dead_unit","processed",signal_key)

func clean_up_skill():
	caster = null
	targets.clear()
	
	disconnect_from_remove_dead_unit()
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
	
	var new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"clean_up_skill","emit",new_signal_key)
	EventBus.clean_up_skill.emit(self,new_signal_key)
	
	ConsoleLog.SIGNAL(self,"combat_turn_ended","processed",signal_key)
