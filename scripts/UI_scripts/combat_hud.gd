extends Control

var is_display_unit_info_connected : bool = false
var is_new_selected_unit_connected : bool = false
var is_disable_combat_actions_connected : bool = false
var is_enable_combat_hud_actions_connected : bool = false
var is_make_combat_hud_skill_buttons_connected : bool = false
var is_remove_combat_hud_skill_buttons_connected : bool = false

var are_non_skill_buttons_disabled : bool = false

@onready var rich_text_label: RichTextLabel = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/RichTextLabel

@onready var stat_portrait : TextureRect = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/MarginContainer/TextureRect
@onready var selected_unit_portrait : TextureRect = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer2/TextureRect

@onready var attack_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/attack_button
@onready var guard_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/guard_button
@onready var channel_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer6/channel_button
@onready var item_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer4/item_button
@onready var skill_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer3/skill_button

@onready var skill_buttons_vbox: VBoxContainer = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer3/ScrollContainer/skill_buttons_vbox

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	connect_to_display_unit_info()
	connect_to_new_selected_unit()
	connect_to_disable_combat_hud_actions()
	connect_to_enable_combat_hud_actions()
	connect_to_make_combat_hud_skill_buttons()
	connect_to_remove_combat_hud_skill_buttons()
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"hud_scene_has_loaded","emit",new_signal_key)
	EventBus.hud_scene_has_loaded.emit(new_signal_key)

func connect_to_remove_combat_hud_skill_buttons():
	if not is_remove_combat_hud_skill_buttons_connected:
		is_remove_combat_hud_skill_buttons_connected = true
		EventBus.remove_combat_hud_skill_buttons.connect(_remove_combat_hud_skill_buttons)
		ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","connected",1)

func disconnect_fromremove_combat_hud_skill_buttons():
	if is_remove_combat_hud_skill_buttons_connected:
		is_remove_combat_hud_skill_buttons_connected = false
		EventBus.remove_combat_hud_skill_buttons.disconnect(_remove_combat_hud_skill_buttons)
		ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","disconnected",0)

func _remove_combat_hud_skill_buttons(signal_key : int):
	if are_non_skill_buttons_disabled:
		disable_non_skill_buttons(false)
		clear_skill_buttons_vbox()
	ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","processed",signal_key)

func clear_skill_buttons_vbox():
	var new_array : Array[Node] = skill_buttons_vbox.get_children()
	for i in new_array:
		i.queue_free()

func connect_to_make_combat_hud_skill_buttons():
	if not is_make_combat_hud_skill_buttons_connected:
		is_make_combat_hud_skill_buttons_connected = true
		EventBus.make_combat_hud_skill_buttons.connect(_make_combat_hud_skill_buttons)
		ConsoleLog.SIGNAL(self,"make_combat_hud_skill_buttons","connected",1)

func disconnect_from_make_combat_hud_skill_buttons():
	if is_make_combat_hud_skill_buttons_connected:
		is_make_combat_hud_skill_buttons_connected = false
		EventBus.make_combat_hud_skill_buttons.disconnect(_make_combat_hud_skill_buttons)
		ConsoleLog.SIGNAL(self,"make_combat_hud_skill_buttons","disconnected",0)

func _make_combat_hud_skill_buttons(skill_array : Array[String],signal_key : int):
	
	for i in skill_array:
		var new_button = Button.new()
		new_button.text = i.capitalize()
		new_button.pressed.connect(_on_skill_selected.bind(i))
		skill_buttons_vbox.add_child.call_deferred(new_button)
	
	disable_non_skill_buttons(true)
	ConsoleLog.SIGNAL(self,"make_combat_hud_skill_buttons","processed",signal_key)

func disable_non_skill_buttons(disable : bool):
	are_non_skill_buttons_disabled = disable
	attack_button.disabled = disable
	guard_button.disabled = disable
	channel_button.disabled = disable
	item_button.disabled = disable
	

func connect_to_disable_combat_hud_actions():
	if not is_disable_combat_actions_connected:
		is_disable_combat_actions_connected = true
		EventBus.disable_combat_hud_actions.connect(_disable_combat_hud_actions)
		ConsoleLog.SIGNAL(self,"disable_combat_hud_actions","connected",1)

func disconnect_from_disable_combat_hud_actions():
	if is_disable_combat_actions_connected:
		is_disable_combat_actions_connected = false
		EventBus.disable_combat_hud_actions.disconnect(_disable_combat_hud_actions)
		ConsoleLog.SIGNAL(self,"disable_combat_hud_actions","disconnected",0)

func _disable_combat_hud_actions(signal_key):
	attack_button.disabled = true
	guard_button.disabled = true
	channel_button.disabled = true
	skill_button.disabled = true
	item_button.disabled = true
	ConsoleLog.SIGNAL(self,"disable_combat_hud_actions","processed",signal_key)

func connect_to_enable_combat_hud_actions():
	if not is_enable_combat_hud_actions_connected:
		is_enable_combat_hud_actions_connected = true
		EventBus.enable_combat_hud_actions.connect(_enable_combat_hud_actions)
		ConsoleLog.SIGNAL(self,"enable_combat_hud_actions","connected",1)

func disconnect_from_enable_combat_hud_actions():
	if is_enable_combat_hud_actions_connected:
		is_enable_combat_hud_actions_connected = false
		EventBus.enable_combat_hud_actions.disconnect(_enable_combat_hud_actions)
		ConsoleLog.SIGNAL(self,"enable_combat_hud_actions","disconnected",0)

func _enable_combat_hud_actions(signal_key):
	attack_button.disabled = false
	guard_button.disabled = false
	channel_button.disabled = false
	skill_button.disabled = false
	item_button.disabled = false
	ConsoleLog.SIGNAL(self,"enable_combat_hud_actions","processed",signal_key)

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
	if are_non_skill_buttons_disabled:
		_remove_combat_hud_skill_buttons(2)
	else:
		_on_skill_selected("skill")

func _on_item_button_pressed() -> void:
	ConsoleLog.INPUT("item_button","pressed",[])

func _on_end_turn_button_pressed() -> void:
	ConsoleLog.INPUT("end_turn_button","pressed",[])
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"end_turn_button_pressed","emit",new_signal_key)
	EventBus.end_turn_button_pressed.emit(new_signal_key)
