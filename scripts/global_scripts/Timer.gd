extends Node

var timer : Timer

enum condition_of_day {
	is_day,
	is_night,
	is_dusk,
	is_dawn
}

var current_condition_of_day : condition_of_day

## The duration of a day in seconds. Default is set to 1800 seconds (30 minutes).
# var day_duration : int = 1800
var day_duration : int = 10

var time_left_from_day : int = day_duration

func _init() -> void:
	# This function is called when the node is initialized.
	# You can perform any necessary setup here.
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_timer(_timer : Timer) -> void:
	timer = _timer


func start_default_timer(signal_key : int):
	timer.start(day_duration)
	ConsoleLog.SIGNAL(self, "start_default_day_timer", "processed", signal_key)


func set_and_start_timer(duration : int, signal_key : int):
	timer.start(duration)
	ConsoleLog.SIGNAL(self, "set_and_start_day_timer", "processed", signal_key)


func pause_timer(signal_key : int):
	timer.set_paused(true)
	ConsoleLog.SIGNAL(self, "pause_day_timer","processed", signal_key)


func unpause_timer(signal_key : int):
	timer.set_paused(false)
	ConsoleLog.SIGNAL(self, "unpause_day_timer","processed", signal_key)


func on_timer_timeout() -> void:
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self, "day_timer_timeout","emit", new_signal_key)
	EventBus.day_timer_timout.emit(new_signal_key)
