extends Node

@onready var main_canvas_layer: CanvasLayer = $MainCanvasLayer
@onready var day_timer: Timer = $day_timer

var is_load_ui_scene_connected : bool = false
var is_load_scene_connected : bool = false
var is_load_hud_scene_connected : bool = false

var is_set_and_start_day_timer_connected : bool = false
var is_pause_day_timer_connected : bool = false
var is_unpause_day_timer_connected : bool = false

var current_ui_scene : Control
var current_hud_scene : Control
var current_scene : Node2D

var main_menu_packed_scene : PackedScene = preload("res://scenes/UI_scenes/main_menu.tscn")

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	connect_to_load_ui_scene()
	connect_to_load_scene()
	connect_to_load_hud_scene()
	
	connect_to_set_and_start_day_timer()
	connect_to_pause_day_timer()
	connect_to_unpause_day_timer()
	
	var new_main_menu : Control = main_menu_packed_scene.instantiate()
	current_ui_scene = new_main_menu
	main_canvas_layer.add_child(new_main_menu)

func connect_to_set_and_start_day_timer():
	if not is_set_and_start_day_timer_connected:
		is_set_and_start_day_timer_connected = true
		EventBus.set_and_start_day_timer.connect(_set_and_start_day_timer)
		ConsoleLog.SIGNAL(self,"set_and_start_day_timer","connected",1)

func disconnect_from_set_and_start_day_timer():
	if is_set_and_start_day_timer_connected:
		is_set_and_start_day_timer_connected = false
		EventBus.set_and_start_day_timer.disconnect(_set_and_start_day_timer)
		ConsoleLog.SIGNAL(self,"set_and_start_day_timer","disconnected",0)

func connect_to_pause_day_timer():
	if not is_pause_day_timer_connected:
		is_pause_day_timer_connected = true
		EventBus.pause_day_timer.connect(_pause_day_timer)
		ConsoleLog.SIGNAL(self,"pause_day_timer","connected",1)

func disconnect_from_pause_day_timer():
	if is_pause_day_timer_connected:
		is_pause_day_timer_connected = false
		EventBus.pause_day_timer.disconnect(_pause_day_timer)
		ConsoleLog.SIGNAL(self,"pause_day_timer","disconnected",0)

func connect_to_unpause_day_timer():
	if not is_unpause_day_timer_connected:
		is_unpause_day_timer_connected = true
		EventBus.unpause_day_timer.connect(_unpause_day_timer)
		ConsoleLog.SIGNAL(self,"unpause_day_timer","connected",1)

func disconnect_from_unpause_day_timer():
	if is_unpause_day_timer_connected:
		is_unpause_day_timer_connected = false
		EventBus.unpause_day_timer.disconnect(_unpause_day_timer)
		ConsoleLog.SIGNAL(self,"unpause_day_timer","disconnected",0)

func connect_to_load_ui_scene():
	if not is_load_ui_scene_connected:
		is_load_ui_scene_connected = true
		EventBus.load_ui_scene.connect(_load_ui_scene)
		ConsoleLog.SIGNAL(self,"load_ui_scene","connected",1)

func disconnect_from_load_ui_scene():
	if is_load_ui_scene_connected:
		is_load_ui_scene_connected = false
		EventBus.load_ui_scene.disconnect(_load_ui_scene)
		ConsoleLog.SIGNAL(self,"load_ui_scene","disconnected",0)

func connect_to_load_scene():
	if not is_load_scene_connected:
		is_load_scene_connected = true
		EventBus.load_scene.connect(_load_scene)
		ConsoleLog.SIGNAL(self,"load_scene","connected",1)

func disconnect_from_load_scene():
	if is_load_scene_connected:
		is_load_scene_connected = false
		EventBus.load_scene.disconnect(_load_scene)
		ConsoleLog.SIGNAL(self,"load_scene","disconnected",0)

func connect_to_load_hud_scene():
	if not is_load_hud_scene_connected:
		is_load_hud_scene_connected = true
		EventBus.load_hud_scene.connect(_load_hud_scene)
		ConsoleLog.SIGNAL(self,"lad_hud_scene","connected",1)

func disconnect_from_load_hud_scene():
	if is_load_hud_scene_connected:
		is_load_hud_scene_connected = false
		EventBus.load_hud_scene.disconnect(_load_hud_scene)
		ConsoleLog.SIGNAL(self,"load_hud_scene","disconnected",0)

func _load_ui_scene(ui_scene : Control, signal_key : int):
	if current_ui_scene != null:
		current_ui_scene.queue_free()
		ConsoleLog.SCENE(current_ui_scene,false)
	if current_scene != null:
		current_scene.queue_free()
		ConsoleLog.SCENE(current_scene,false)
		current_scene = null
	if current_hud_scene != null:
		current_hud_scene.queue_free()
		ConsoleLog.SCENE(current_hud_scene,false)
		current_hud_scene = null
	current_ui_scene = ui_scene
	main_canvas_layer.add_child.call_deferred(ui_scene)
	ConsoleLog.SIGNAL(self,"load_ui_scene","processed",signal_key)

func _load_hud_scene(hud_scene : Control, signal_key : int):
	if current_hud_scene != null:
		current_hud_scene.queue_free()
		ConsoleLog.SCENE(current_hud_scene,false)
	else:
		current_hud_scene = hud_scene
		main_canvas_layer.add_child.call_deferred(hud_scene)
	ConsoleLog.SIGNAL(self,"load_hud_scene","processed",signal_key)

func _load_scene(scene : Node2D, signal_key : int):
	if current_scene != null:
		current_scene.queue_free()
		ConsoleLog.SCENE(current_scene,false)
	if current_ui_scene != null:
		current_ui_scene.queue_free()
		ConsoleLog.SCENE(current_ui_scene,false)
		current_ui_scene = null
	if current_hud_scene != null:
		current_hud_scene.queue_free()
		ConsoleLog.SCENE(current_hud_scene,false)
		current_hud_scene = null
	current_scene = scene
	add_child.call_deferred(scene)
	ConsoleLog.SIGNAL(self,"load_scene","processed",signal_key)

func _set_and_start_day_timer(duration : int, signal_key : int):
	day_timer.start(duration)
	ConsoleLog.SIGNAL(self,"set_and_start_day_timer","processed",signal_key)

func _pause_day_timer(signal_key : int):
	day_timer.stop()
	ConsoleLog.SIGNAL(self,"pause_day_timer","processed",signal_key)

func _unpause_day_timer(signal_key : int):
	var new_duration : float = day_timer.time_left
	day_timer.start(new_duration)
	ConsoleLog.SIGNAL(self,"unpause_day_timer","processed",signal_key)

func _on_day_timer_timeout() -> void:
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"day_timer_timeout","emit",new_signal_key)
	EventBus.day_timer_timout.emit(new_signal_key)
