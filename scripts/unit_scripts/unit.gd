@abstract extends Node2D

class_name unit

var is_display_unit_info_connected : bool = false

var unit_name : String

var unit_health : int
var unit_current_health : int

var unit_atk : int
var unit_def : int

func _ready() -> void:
	connect_to_display_unit_info()

func connect_to_display_unit_info():
	if not is_display_unit_info_connected:
		is_display_unit_info_connected = true
		EventBus.display_unit_info.connect(_display_unit_info)
		ConsoleLog.SIGNAL(self,"display_unit_signal","connected",1)

func disconnect_from_display_unit_info():
	if is_display_unit_info_connected:
		is_display_unit_info_connected = false
		EventBus.display_unit_info.connect(_display_unit_info)
		ConsoleLog.SIGNAL(self,"display_unit_signal","disconnected",0)

func _display_unit_info(selected_unit : unit,signal_key : int):
	if selected_unit == self:
		ConsoleLog.INFO(self,["unit_name","unit_health","unit_current_health","unit_atk","unit_def"],[unit_name,unit_health,unit_current_health,unit_atk,unit_def])
		ConsoleLog.SIGNAL(self,"display_unit_info","processed",signal_key)
