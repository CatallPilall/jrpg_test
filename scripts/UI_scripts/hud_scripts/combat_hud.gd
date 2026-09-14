extends Control

var are_non_skill_buttons_disabled : bool = false
var are_non_item_buttons_disabled : bool = false

var item_button_disabled : bool = false

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
	_connect_signals()

	# var new_signal_key : int = EventBus.generate_signal_key()
	# ConsoleLog.SIGNAL(self,"combat_hud_has_loaded","emit",new_signal_key)
	# EventBus.combat_hud_has_loaded.emit(new_signal_key)


func _connect_signals() -> void:
	EventBus.connect_function_with_signal(self, _display_unit_info, EventBus.display_unit_info)
	EventBus.connect_function_with_signal(self, _new_selected_unit, EventBus.new_selected_unit)
	EventBus.connect_function_with_signal(self, _disable_combat_hud_actions, EventBus.disable_combat_hud_actions)
	EventBus.connect_function_with_signal(self, _enable_combat_hud_actions, EventBus.enable_combat_hud_actions)
	EventBus.connect_function_with_signal(self, _make_combat_hud_skill_buttons, EventBus.make_combat_hud_skill_buttons)
	EventBus.connect_function_with_signal(self, _remove_combat_hud_skill_buttons, EventBus.remove_combat_hud_skill_buttons)
	EventBus.connect_function_with_signal(self, _make_combat_hud_item_buttons, EventBus.make_combat_hud_item_buttons)
	EventBus.connect_function_with_signal(self, _disable_item_button, EventBus.disable_item_button)


func _disable_item_button(disabled : bool, signal_key : int):
	item_button_disabled = disabled
	item_button.disabled = item_button_disabled
	ConsoleLog.SIGNAL(self,"disable_item_button","processed",signal_key)


func _remove_combat_hud_skill_buttons(signal_key : int):
	if are_non_skill_buttons_disabled:
		disable_non_skill_buttons(false)
	if are_non_item_buttons_disabled:
		disable_non_item_buttons(false)
	clear_skill_buttons_vbox()
	ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","processed",signal_key)


func clear_skill_buttons_vbox():
	var new_array : Array[Node] = skill_buttons_vbox.get_children()
	for i in new_array:
		i.queue_free()


func _make_combat_hud_skill_buttons(skill_array : Array[String],signal_key : int):

	for i in skill_array:
		var new_button = Button.new()
		new_button.text = i.capitalize()
		new_button.pressed.connect(_on_skill_selected.bind(i))
		skill_buttons_vbox.add_child.call_deferred(new_button)

	disable_non_skill_buttons(true)
	ConsoleLog.SIGNAL(self,"make_combat_hud_skill_buttons","processed",signal_key)


func _make_combat_hud_item_buttons(signal_key : int):
	for i in TeamRoster.consumables:
		var new_button = Button.new()
		new_button.text = i.item_name
		new_button.pressed.connect(_on_item_selected.bind(i))
		skill_buttons_vbox.add_child.call_deferred(new_button)

	disable_non_item_buttons(true)
	ConsoleLog.SIGNAL(self,"make_combat_hud_item_buttons","processed",signal_key)


func disable_non_item_buttons(disable : bool):
	are_non_item_buttons_disabled = disable
	attack_button.disabled = disable
	guard_button.disabled = disable
	channel_button.disabled = disable
	skill_button.disabled = disable


func disable_non_skill_buttons(disable : bool):
	are_non_skill_buttons_disabled = disable
	attack_button.disabled = disable
	guard_button.disabled = disable
	channel_button.disabled = disable
	if not item_button_disabled:
		item_button.disabled = disable


func _disable_combat_hud_actions(signal_key):
	attack_button.disabled = true
	guard_button.disabled = true
	channel_button.disabled = true
	skill_button.disabled = true
	item_button.disabled = true
	ConsoleLog.SIGNAL(self,"disable_combat_hud_actions","processed",signal_key)


func _enable_combat_hud_actions(signal_key):
	are_non_skill_buttons_disabled = false
	attack_button.disabled = false
	guard_button.disabled = false
	channel_button.disabled = false
	skill_button.disabled = false
	item_button.disabled = false
	ConsoleLog.SIGNAL(self,"enable_combat_hud_actions","processed",signal_key)


func _display_unit_info(selected_unit : unit, signal_key : int):
	var new_text : String = ""

	var variable_names : Array[String] = ["name","health","atk","def","speed"]
	var variable_values : Array = [selected_unit.unit_name,selected_unit.active_stats.get("health_points"),selected_unit.active_stats.get("phys_atk"),selected_unit.active_stats.get("phys_def"),selected_unit.active_stats.get("speed")]

	for i in range(variable_names.size()):
		new_text += variable_names[i] + " : " + JSON.stringify(variable_values[i], "\t") + "\n"

	rich_text_label.text = new_text
	stat_portrait.texture = load(selected_unit.unit_sprite_path)
	ConsoleLog.SIGNAL(self,"display_unit_info","processed",signal_key)


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
		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"combat_state_changed_via_combat_hud","emit",new_signal_key)
		EventBus.combat_state_changed_via_combat_hud.emit(new_signal_key)
	else:
		_on_skill_selected("skill")


func _on_item_button_pressed() -> void:
	ConsoleLog.INPUT("item_button","pressed",[])
	if are_non_item_buttons_disabled:
		_remove_combat_hud_skill_buttons(2)
		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"combat_state_changed_via_combat_hud","emit",new_signal_key)
		EventBus.combat_state_changed_via_combat_hud.emit(new_signal_key)
	else:
		_on_skill_selected("item")


func _on_item_selected(selected_item : item):
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"item_button_pressed","emit",new_signal_key)
	EventBus.item_button_pressed.emit(selected_item, new_signal_key)


func _on_end_turn_button_pressed() -> void:
	_remove_combat_hud_skill_buttons(2)
	ConsoleLog.INPUT("end_turn_button","pressed",[])
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"end_turn_button_pressed","emit",new_signal_key)
	EventBus.end_turn_button_pressed.emit(new_signal_key)
