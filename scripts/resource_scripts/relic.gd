extends Resource

var is_combat_started_connected : bool = false
var is_combat_ended_connected : bool = false

var is_calculating_skill_speed_connected : bool = false

var holder : unit

@export var rel_skill : Array[relic_skill]

@export var calculating_skill_speed : bool

func eqiup_relic(new_holder : unit):
	holder = new_holder
	connect_to_combat_started()

func connect_to_combat_started():
	if not is_combat_started_connected:
		is_combat_started_connected = true
		EventBus.combat_started.connect(_connect_relevant_signals)
		ConsoleLog.SIGNAL(self,"comat_started","connected",1)

func disconnect_from_combat_started():
	if is_combat_started_connected:
		is_combat_started_connected = false
		EventBus.combat_started.disconnect(_connect_relevant_signals)
		ConsoleLog.SIGNAL(self,"comat_started","disconnected",0)

func _connect_relevant_signals():
	disconnect_from_combat_started()
	connect_to_combat_ended()
	if calculating_skill_speed:
		connect_to_calculating_skill_speed()

func connect_to_combat_ended():
	if not is_combat_ended_connected:
		is_combat_ended_connected = true
		EventBus.combat_ended.connect(_disconnect_relevant_signals)
		ConsoleLog.SIGNAL(self,"combat_ended","connected",1)

func disconnect_from_combat_ended():
	if is_combat_ended_connected:
		is_combat_ended_connected = false
		EventBus.combat_ended.disconnect(_disconnect_relevant_signals)
		ConsoleLog.SIGNAL(self,"combat_ended","disconnected",0)

func _disconnect_relevant_signals():
	connect_to_combat_started()
	disconnect_from_combat_ended()
	if calculating_skill_speed:
		disconnect_from_calculating_skill_speed()

func connect_to_calculating_skill_speed():
	if not is_calculating_skill_speed_connected:
		is_calculating_skill_speed_connected = true
		EventBus.calculating_skill_speed.connect(_execute_relic_skill)
		ConsoleLog.SIGNAL(self,"calculating_skill_speed","connected",1)

func disconnect_from_calculating_skill_speed():
	if is_calculating_skill_speed_connected:
		is_calculating_skill_speed_connected = false
		EventBus.calculating_skill_speed.disconnect(_execute_relic_skill)
		ConsoleLog.SIGNAL(self,"calculating_skill_speed","disconnected",0)

func _execute_relic_skill(caster : unit, casted_skill : skill, signal_key : int):
	for i : relic_skill in rel_skill:
		i.execute_relic_skill(caster,casted_skill)
	ConsoleLog.SIGNAL(self,"execute_relic_skill","processed",signal_key)
