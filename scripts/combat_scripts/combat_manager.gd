extends Node

var attack_skill : Script = preload("res://scripts/skill_scripts/attack_skill.gd")

var skill_dict : Dictionary = {"attack": EventBus.execute_attack_skill}

var is_combat_attack_button_connected : bool = false
var is_combat_guard_button_connected : bool = false
var is_combat_channel_button_connected : bool = false
var is_combat_skill_button_connected : bool = false
var is_combat_item_button_connected : bool = false

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	connect_to_combat_attack_button()
	connect_to_combat_guard_button()
	connect_to_combat_channel_button()
	connect_to_combat_skill_button()
	connect_to_combat_item_button()


func connect_to_combat_attack_button():
	if not is_combat_attack_button_connected:
		is_combat_attack_button_connected = true
		EventBus.combat_attack_button.connect(_combat_attack_button)
		ConsoleLog.SIGNAL(self,"combat_attack_button","connected",1)

func disconnect_from_combat_attack_button():
	if is_combat_attack_button_connected:
		is_combat_attack_button_connected = false
		EventBus.combat_attack_button.disconnect(_combat_attack_button)
		ConsoleLog.SIGNAL(self,"combat_attack_button","disconnected",0)

func connect_to_combat_guard_button():
	if not is_combat_guard_button_connected:
		is_combat_guard_button_connected = true
		EventBus.combat_guard_button.connect(_combat_guard_button)
		ConsoleLog.SIGNAL(self,"combat_guard_button","connected",1)

func disconnect_from_combat_guard_button():
	if is_combat_guard_button_connected:
		is_combat_guard_button_connected = false
		EventBus.combat_guard_button.disconnect(_combat_guard_button)
		ConsoleLog.SIGNAL(self,"combat_guard_button","disconnected",0)

func connect_to_combat_channel_button():
	if not is_combat_channel_button_connected:
		is_combat_channel_button_connected = true
		EventBus.combat_channel_button.connect(_combat_channel_button)
		ConsoleLog.SIGNAL(self,"combat_channel_button","connected",1)

func disconnect_from_combat_channel_button():
	if is_combat_channel_button_connected:
		is_combat_channel_button_connected = false
		EventBus.combat_channel_button.disconnect(_combat_channel_button)
		ConsoleLog.SIGNAL(self,"combat_channel_button","disconnected",0)

func connect_to_combat_skill_button():
	if not is_combat_skill_button_connected:
		is_combat_skill_button_connected = true
		EventBus.combat_skill_button.connect(_combat_skill_button)
		ConsoleLog.SIGNAL(self,"combat_skill_button","connected",1)

func disconnect_from_combat_skill_button():
	if is_combat_skill_button_connected:
		is_combat_skill_button_connected = false
		EventBus.combat_skill_button.disconnect(_combat_skill_button)
		ConsoleLog.SIGNAL(self,"combat_skill_button","disconnected",0)

func connect_to_combat_item_button():
	if not is_combat_item_button_connected:
		is_combat_item_button_connected = true
		EventBus.combat_item_button.connect(_combat_item_button)
		ConsoleLog.SIGNAL(self,"combat_item_button","connected",1)

func disconnect_from_combat_item_button():
	if is_combat_item_button_connected:
		is_combat_item_button_connected = false
		EventBus.combat_item_button.disconnect(_combat_item_button)
		ConsoleLog.SIGNAL(self,"combat_item_button","disconnected",0)

func _combat_attack_button(signal_key : int):
	ConsoleLog.SIGNAL(self,"combat_attack_button","processed",signal_key)

func _combat_guard_button(signal_key : int):
	ConsoleLog.SIGNAL(self,"combat_guard_button","processed",signal_key)

func _combat_channel_button(signal_key : int):
	ConsoleLog.SIGNAL(self,"combat_channel_button","processed",signal_key)

func _combat_skill_button(signal_key : int):
	ConsoleLog.SIGNAL(self,"combat_skill_button","processed",signal_key)

func _combat_item_button(signal_key : int):
	ConsoleLog.SIGNAL(self,"combat_item_button","processed",signal_key)
