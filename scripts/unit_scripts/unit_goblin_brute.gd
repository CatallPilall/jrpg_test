extends unit_goblin

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	unit_name = "goblin brute"
	unit_health = 50
	unit_current_health = 50
	unit_atk = 10
	unit_def = 5
	super()
