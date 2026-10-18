extends Node

enum time_of_day {
	is_day,
	is_night,
	is_dusk,
	is_dawn
}

var timer_counter_id : int = 0

var current_time_of_day : time_of_day

var current_time_minutes : int = 0
var current_time_hours : int = 0

var time_update_interval_in_seconds : float

var max_day_duration_unit: int = 24 * 60
var current_day_time_in_units : int = 0

var timer_started : bool = false
var timer_paused : bool = false


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


func _convert_time_to_string() -> String:
	var time_string = "%02d : %02d" % [current_time_hours, current_time_minutes]
	return time_string + " --- DAY_TIME_UNITS: " + str(current_day_time_in_units) + " / " + str(max_day_duration_unit)


func _calc_current_time_of_day():
	if current_time_hours < 6:
		current_time_of_day = time_of_day.is_night
	elif current_time_hours < 10:
		current_time_of_day = time_of_day.is_dawn
	elif current_time_hours < 18:
		current_time_of_day = time_of_day.is_day
	elif current_time_hours < 22:
		current_time_of_day = time_of_day.is_dusk
	else:
		current_time_of_day = time_of_day.is_night


func _update_time():
	current_time_minutes = wrapi(current_time_minutes + 1, 0, 60)
	if current_time_minutes == 0:
		current_time_hours = wrapi(current_time_hours + 1, 0, 24)

	current_day_time_in_units = wrapi(current_day_time_in_units + 1, 0, max_day_duration_unit)


func _background_time_check(_timer_counter_id : int) -> void:
	_calc_current_time_of_day()
	EventBus.emit_signal_no_log(EventBus.timer_updated, [" --- " + _convert_enum_to_string() + " --- " + _convert_time_to_string() + " --- "])

	while true:
		await get_tree().create_timer(time_update_interval_in_seconds).timeout

		if _timer_counter_id != timer_counter_id:
			ConsoleLog.DEBUG("Timer stopped or restarted, exiting background time check")
			return

		if timer_paused:
			continue

		_update_time()
		_calc_current_time_of_day()

		EventBus.emit_signal_no_log(EventBus.timer_updated, [" --- " + _convert_enum_to_string() + " --- " + _convert_time_to_string() + " --- "])


func start_timer(_hours : int = 0, _minutes : int = 0, _update_interval : float = 0.5) -> void:
	if timer_started:
		ConsoleLog.WARNING("Timer already started")
		return
	ConsoleLog.DEBUG("start_timer")

	timer_counter_id += 1
	var current_timer_counter_id : int = timer_counter_id

	timer_started = true
	timer_paused = false

	current_time_minutes = wrapi(_minutes, 0, 60)
	current_time_hours = wrapi(_hours, 0, 24)
	current_day_time_in_units = wrapi(current_time_hours * 60 + current_time_minutes, 0, max_day_duration_unit)
	time_update_interval_in_seconds = _update_interval

	_background_time_check(current_timer_counter_id)


func restart_timer(_hours : int = 0, _minutes : int = 0, _update_interval : float = 0.5):
	ConsoleLog.DEBUG("restart_timer")
	timer_started = false

	start_timer(_hours, _minutes, _update_interval)


func pause_timer():
	ConsoleLog.DEBUG("pause_timer")
	timer_paused = true


func resume_timer():
	ConsoleLog.DEBUG("unpause_timer")
	timer_paused = false


func stop_timer() -> void:
	ConsoleLog.DEBUG("stop_timer")
	timer_started = false
	timer_counter_id += 1
