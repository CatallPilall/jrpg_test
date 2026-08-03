extends Control

var is_display_unit_info_connected : bool = false

@onready var rich_text_label: RichTextLabel = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/RichTextLabel

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	connect_to_display_unit_info()

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
	
	var variable_names : Array[String] = ["name","health","atk","def"]
	var variable_values : Array = [selected_unit.name,selected_unit.unit_current_health,selected_unit.unit_atk,selected_unit.unit_def]
	
	for i in range(variable_names.size()):
		new_text += variable_names[i] + " : " + JSON.stringify(variable_values[i], "\t") + "\n"
	
	rich_text_label.text = new_text
	ConsoleLog.SIGNAL(self,"display_unit_info","processed",signal_key)

func _on_attack_button_pressed() -> void:
	ConsoleLog.INPUT("attack_button","pressed",[])
	var new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"combat_attack_button","emit",new_signal_key)
	EventBus.combat_attack_button.emit(new_signal_key)

func _on_guard_button_pressed() -> void:
	ConsoleLog.INPUT("guard_button","pressed",[])
	var new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"combat_guard_button","emit",new_signal_key)
	EventBus.combat_guard_button.emit(new_signal_key)

func _on_channel_button_pressed() -> void:
	ConsoleLog.INPUT("channel_button","pressed",[])
	var new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"combat_channel_button","emit",new_signal_key)
	EventBus.combat_channel_button.emit(new_signal_key)

func _on_skill_button_pressed() -> void:
	ConsoleLog.INPUT("skill_button","pressed",[])
	var new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"combat_skill_button","emit",new_signal_key)
	EventBus.combat_skill_button.emit(new_signal_key)

func _on_item_button_pressed() -> void:
	ConsoleLog.INPUT("item_button","pressed",[])
	var new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"combat_item_button","emit",new_signal_key)
	EventBus.combat_item_button.emit(new_signal_key)
