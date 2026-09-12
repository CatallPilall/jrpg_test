extends Node

var timer : Timer

enum time_of_day {
	is_day,
	is_night,
	is_dusk,
	is_dawn
}

var current_time_of_day : time_of_day

## The duration of a day in seconds. Default is set to 1800 seconds (30 minutes).
# var day_duration : int = 1800
var day_duration : float = 100.0

var time_left_from_day : float = day_duration


func _init() -> void:
	# This function is called when the node is initialized.
	# You can perform any necessary setup here.
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _convert_enum_to_string() -> String:
	match current_time_of_day:
		time_of_day.is_day:
			return "day"
		time_of_day.is_night:
			return "night"
		time_of_day.is_dusk:
			return "dusk"
		time_of_day.is_dawn:
			return "dawn"
		_:
			return "unknown"


func _calc_current_time_of_day():
	var time_passed : float = day_duration - timer.time_left
	var day_fraction : float = time_passed / day_duration

	if day_fraction < 0.1:
		current_time_of_day = time_of_day.is_dawn
	elif day_fraction < 0.5:
		current_time_of_day = time_of_day.is_day
	elif day_fraction < 0.6:
		current_time_of_day = time_of_day.is_dusk
	else:
		current_time_of_day = time_of_day.is_night


func _background_time_check():
	while true:
		await get_tree().create_timer(2.0).timeout
		_calc_current_time_of_day()
		ConsoleLog.DEBUG(self, "background_timer_check : " + _convert_enum_to_string())


func set_timer(_timer : Timer) -> void:
	timer = _timer
	timer.timeout.connect(on_timer_timeout)


func start_default_timer():
	timer.start(day_duration)
	_background_time_check()
	ConsoleLog.DEBUG(self, "start_default_timer")


func set_and_start_timer(duration : float):
	timer.start(duration)
	_background_time_check()
	ConsoleLog.DEBUG(self, "set_and_start_timer")


func pause_timer():
	timer.set_paused(true)
	ConsoleLog.DEBUG(self, "pause_timer")


func unpause_timer():
	timer.set_paused(false)
	ConsoleLog.DEBUG(self, "unpause_timer")


func on_timer_timeout() -> void:
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self, "day_timer_timeout","emit", new_signal_key)
	# EventBus.day_timer_timout.emit(new_signal_key)
