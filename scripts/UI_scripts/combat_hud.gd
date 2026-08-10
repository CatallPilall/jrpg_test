extends Control

var is_display_unit_info_connected : bool = false
var is_new_selected_unit_connected : bool = false

@onready var rich_text_label: RichTextLabel = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/RichTextLabel

@onready var stat_portrait : TextureRect = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/MarginContainer/TextureRect
@onready var selected_unit_portrait : TextureRect = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer2/TextureRect

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	connect_to_display_unit_info()
	connect_to_new_selected_unit()
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"hud_scene_has_loaded","emit",new_signal_key)
	EventBus.hud_scene_has_loaded.emit(new_signal_key)

func connect_to_display_unit_info():
	if not is_display_unit_info_connected:
		is_display_unit_info_connected = true
		EventBus.display_unit_info.connect(_display_unit_info)
		ConsoleLog.SIGNAL(self,"display_unit_info","connected",1)

func disconnect_from_display_unit_info():
	if is_display_unit_info_connected:
		is_display_unit_info_connected = false
		EventBus.display_unit_info.disconnect(_display_unit_info)
		ConsoleLog.SIGNAL(self,"display_unit_info","disconnected",0)

func _display_unit_info(selected_unit : unit, signal_key : int):
	var new_text : String = ""
	
	var variable_names : Array[String] = ["name","health","atk","def","speed"]
	var variable_values : Array = [selected_unit.unit_name,selected_unit.unit_health,selected_unit.unit_atk,selected_unit.unit_def,selected_unit.unit_speed]
	
	for i in range(variable_names.size()):
		new_text += variable_names[i] + " : " + JSON.stringify(variable_values[i], "\t") + "\n"
	
	rich_text_label.text = new_text
	stat_portrait.texture = load(selected_unit.unit_sprite_path)
	ConsoleLog.SIGNAL(self,"display_unit_info","processed",signal_key)

func connect_to_new_selected_unit():
	if not is_new_selected_unit_connected:
		is_new_selected_unit_connected = true
		EventBus.new_selected_unit.connect(_new_selected_unit)
		ConsoleLog.SIGNAL(self,"new_selected_unit","connected",1)
	else:
		ConsoleLog.ERROR(self,"connect_to_new_selected_unit()","new_selected_unit already_connected")

func disconnect_from_new_selected_unit():
	if is_new_selected_unit_connected:
		is_new_selected_unit_connected = false
		EventBus.new_selected_unit.disconnect(_new_selected_unit)
		ConsoleLog.SIGNAL(self,"new_selected_unit","disconnected",0)
	else:
		ConsoleLog.ERROR(self,"disconnect_from_new_selected_unit()","new_selected_unit already_disconnected")

func _new_selected_unit(selected_unit : unit, signal_key : int):
	selected_unit_portrait.texture = load(selected_unit.unit_sprite_path)
	ConsoleLog.SIGNAL(self,"new_selected_unit","processed",signal_key)

func _on_attack_button_pressed() -> void:
	ConsoleLog.INPUT("attack_button","pressed",[])
	_on_skill_selected("attack")

func _on_guard_button_pressed() -> void:
	ConsoleLog.INPUT("guard_button","pressed",[])
	_on_skill_selected("guard")

func _on_channel_button_pressed() -> void:
	ConsoleLog.INPUT("channel_button","pressed",[])
	_on_skill_selected("channel")

func _on_skill_selected(selected_skill : String):
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"skill_button_pressed","emit",new_signal_key)
	EventBus.skill_button_pressed.emit(selected_skill, new_signal_key)

func _on_skill_button_pressed() -> void:
	ConsoleLog.INPUT("skill_button","pressed",[])

func _on_item_button_pressed() -> void:
	ConsoleLog.INPUT("item_button","pressed",[])

func _on_end_turn_button_pressed() -> void:
	ConsoleLog.INPUT("end_turn_button","pressed",[])
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"end_turn_button_pressed","emit",new_signal_key)
	EventBus.end_turn_button_pressed.emit(new_signal_key)
