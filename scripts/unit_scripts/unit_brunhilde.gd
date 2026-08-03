extends unit_barbarian

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	unit_name = "Brunhilde"
	unit_health = 100
	unit_current_health = 100
	unit_atk = 20
	unit_def = 10
	super()
