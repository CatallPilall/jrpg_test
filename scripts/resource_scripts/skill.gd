extends Resource

class_name skill

var caster : unit
var targets : Array[unit]

var is_combat_turn_ended_connected : bool = false
var is_new_turn_connected : bool = false

enum enum_skill_targeting{NONE,SELF,SINGLE_ENEMY,TEAM_ENEMY}
@export var skill_targeting : enum_skill_targeting

enum enum_skill_type{ATTACK,SPELL,ITEM,RELIC}
@export var skill_type : enum_skill_type

@export var phys_damage : int

@export var fire_damage : int

@export var poi_damage : int

@export var healing : int

@export var skill_speed : int

@export var skill_duration : int

@export var item_skill : bool

var cast : bool = true

var total_speed : int

func connect_to_new_turn():
	if not is_new_turn_connected:
		is_new_turn_connected = true
		EventBus.new_turn.connect(_new_turn)
		ConsoleLog.SIGNAL(self,"new_turn","connected",1)

func disconnect_from_new_turn():
	if is_new_turn_connected:
		is_new_turn_connected = false
		EventBus.new_turn.disconnect(_new_turn)
		ConsoleLog.SIGNAL(self,"new_turn","disconnected",0)

func _new_turn(signal_key : int):
	execute_skill()
	ConsoleLog.SIGNAL(self,"new_turn","processed",signal_key)

func set_caster_and_targets(new_caster : unit, new_targets : Array[unit]):
	caster = new_caster
	targets = new_targets
	total_speed = caster.unit_speed + skill_speed
	if item_skill:
		connect_to_new_turn()

func display_skill_data():
	ConsoleLog.INFO(self,["caster","targets","total_speed","skill_duration"],[caster,targets,total_speed,skill_duration])

func execute_skill():
	# Do all checkups if the skill can be cast
	if cast:
		if check_for_dead_caster():
			clean_up_skill()
			return
	check_for_dead_targets()
	#-----------------------------------------
	# For loop executes the Skill itself
	for i in targets:
		ConsoleLog.DEBUG(self,"current target "+ str(i))
		if phys_damage:
			deal_phys_damage(i)
		if fire_damage:
			deal_fire_damage(i)
		if poi_damage:
			deal_poi_damage(i)
		if healing:
			heal(i)
		check_lethal(i)
	#-----------------------------------------
	# Prepare the Skill for next turn
	cast = false
	if skill_duration == 0:
		clean_up_skill()
	else:
		skill_duration -= 1
	#-----------------------------------------

func deal_phys_damage(my_target : unit):
	var resulting_damage : int = round(float(caster.unit_atk + phys_damage) * (100 - my_target.unit_def)/100)
	my_target.unit_health -= resulting_damage

func deal_fire_damage(my_target : unit):
	var resulting_damage : int = round(float(fire_damage) * (100 - my_target.unit_fire_resist)/100)
	my_target.unit_health -= resulting_damage

func deal_poi_damage(my_target : unit):
	var resulting_damage : int = round(float(poi_damage) * (100 - my_target.unit_poi_resist)/100)
	my_target.unit_health -= resulting_damage

func heal(my_target : unit):
	my_target.unit_health += healing

func check_lethal(my_target : unit):
	ConsoleLog.DEBUG(self,str(my_target) + " remaining health: " + str(my_target.unit_health))
	if my_target.unit_health <= 0:
		ConsoleLog.MESSAGE(self,str(my_target) + " is dead")
		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"remove_dead_unit","emit",new_signal_key)
		EventBus.remove_dead_unit.emit(my_target,new_signal_key)

func check_for_dead_caster() -> bool:
	if caster.unit_health <= 0:
		return true
	else:
		return false

func check_for_dead_targets():
	for i in targets:
		if i.unit_health <= 0:
			targets.erase(i)
	targets.filter(func(is_not_null): return is_not_null != null)

func clean_up_skill():
	caster = null
	targets.clear()
	if item_skill:
		disconnect_from_new_turn()
	else :
		connect_to_combat_turn_ended()
	
	ConsoleLog.DEBUG(self,"References +1 to Resource at clean_up_skill() "+ str(get_reference_count()))

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
