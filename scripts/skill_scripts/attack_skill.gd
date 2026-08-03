extends skill

var is_execute_attack_skill_connected : bool = false

func _init() -> void:
	ConsoleLog.MESSAGE(self, "initialized")
	connect_to_execute_attack_skill()
	skill_targeting = enum_skill_targeting.SINGLE_ENEMY

func connect_to_execute_attack_skill():
	if not is_execute_attack_skill_connected:
		is_execute_attack_skill_connected = true
		EventBus.execute_attack_skill.connect(_execute_attack_skill)
		ConsoleLog.SIGNAL(self,"execute_attack_skill","connected",1)

func disconnect_from_execute_attack_skill():
	if is_execute_attack_skill_connected:
		is_execute_attack_skill_connected = false
		EventBus.execute_attack_skill.disconnect(_execute_attack_skill)
		ConsoleLog.SIGNAL(self,"execute_attack_skill","disconnected",0)

func _execute_attack_skill(signal_key : int):
	ConsoleLog.SIGNAL(self,"execute_attack_skill","processed",signal_key)
