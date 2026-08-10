extends Node

var skill_dict : Dictionary[String,skill] = {
	"attack":preload("res://resources/skills/attack_skill.tres"),
	"guard":preload("res://resources/skills/guard_skill.tres")
}

var selected_unit : unit

var combat_team_reference : Array[unit]

var selected_skill : skill

var is_skill_button_pressed_connected : bool = false
var is_unit_targets_selected_connected : bool = false
var is_end_turn_button_pressed_connected : bool = false
var is_hud_scene_has_loaded_connected : bool = false
var is_clean_up_skill_connected : bool = false

var skill_order_array : Array[skill]

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	connect_to_skill_button_pressed()
	connect_to_unit_targets_selected()
	connect_to_end_turn_button_pressed()
	connect_to_hud_scene_has_loaded()
	connect_to_clean_up_skill()
	store_combat_team_locally()

func connect_to_clean_up_skill():
	if not is_clean_up_skill_connected:
		is_clean_up_skill_connected = true
		EventBus.clean_up_skill.connect(_clean_up_skill)
		ConsoleLog.SIGNAL(self,"clean_up_skill","connected",1)

func disconnect_from_clean_up_skill():
	if is_clean_up_skill_connected:
		is_clean_up_skill_connected = false
		EventBus.clean_up_skill.disconnect(_clean_up_skill)
		ConsoleLog.SIGNAL(self,"clean_up_skill","disconnected",0)

func _clean_up_skill(skill_to_clean : skill, signal_key : int):
	skill_order_array.erase(skill_to_clean)
	ConsoleLog.SIGNAL(self,"clean_up_skill","processed",signal_key)

func connect_to_hud_scene_has_loaded():
	if not is_hud_scene_has_loaded_connected:
		is_hud_scene_has_loaded_connected = true
		EventBus.hud_scene_has_loaded.connect(_hud_scene_has_loaded)
		ConsoleLog.SIGNAL(self,"hud_scene_has_loaded","connected",1)

func disconnect_from_hud_scene_has_loaded():
	if is_hud_scene_has_loaded_connected:
		is_hud_scene_has_loaded_connected = false
		EventBus.hud_scene_has_loaded.disconnect(_hud_scene_has_loaded)
		ConsoleLog.SIGNAL(self,"hud_scene_has_loaded","disconnected",0)

func _hud_scene_has_loaded(signal_key : int):
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"new_selected_unit","emit",new_signal_key)
	EventBus.new_selected_unit.emit(selected_unit,new_signal_key)
	ConsoleLog.SIGNAL(self,"hud_scene_has_loaded","processed",signal_key)

func store_combat_team_locally():
	combat_team_reference = TeamRoster.combat_team
	new_unit_selected(combat_team_reference[0])

func new_unit_selected(new_selected_unit : unit):
	selected_unit = new_selected_unit

func connect_to_skill_button_pressed():
	if not is_skill_button_pressed_connected:
		is_skill_button_pressed_connected = true
		EventBus.skill_button_pressed.connect(_skill_button_pressed)
		ConsoleLog.SIGNAL(self,"skill_button_pressed","connected",1)

func disconnect_from_skill_button_pressed():
	if is_skill_button_pressed_connected:
		is_skill_button_pressed_connected = false
		EventBus.skill_button_pressed.disconnect(_skill_button_pressed)
		ConsoleLog.SIGNAL(self,"skill_button_pressed","disconnected",0)

func _skill_button_pressed(skill_name : String, signal_key : int):
	
	var new_skill : skill = skill_dict.get(skill_name).duplicate()
	
	selected_skill = new_skill
	ConsoleLog.INFO(self,["skill","reference_count"],[new_skill,new_skill.get_reference_count()])
	ConsoleLog.INFO(self,["selected_skill","selected_unit"],[selected_skill,selected_unit])
	ConsoleLog.SIGNAL(self,"skill_button_pressed","processed",signal_key)

func connect_to_unit_targets_selected():
	if not is_unit_targets_selected_connected:
		is_unit_targets_selected_connected = true
		EventBus.unit_targets_selected.connect(_unit_targets_selected)
		ConsoleLog.SIGNAL(self,"unit_targets_selected","connected",1)

func disconnect_from_unit_targets_selected():
	if is_unit_targets_selected_connected:
		is_unit_targets_selected_connected = false
		EventBus.unit_targets_selected.disconnect(_unit_targets_selected)
		ConsoleLog.SIGNAL(self,"unit_targets_selected","disconnected",0)

func _unit_targets_selected(selected_targets : Array[unit], signal_key : int):
	if selected_skill:
		selected_skill.set_caster_and_targets(selected_unit,selected_targets)
		selected_skill.display_skill_data()
		queue_skill(selected_skill)
		selected_skill = null
		ConsoleLog.SIGNAL(self,"unit_targets_selected","processed",signal_key)

func queue_skill(skill_to_queue : skill):
	skill_order_array.append(skill_to_queue)
	skill_order_array.sort_custom(sort_skill_order_array)
	ConsoleLog.INFO(self,["skill_order_array"],[skill_order_array])

func sort_skill_order_array(a : skill, b : skill):
	if a.total_speed > b.total_speed:
		return true
	return false

func connect_to_end_turn_button_pressed():
	if not is_end_turn_button_pressed_connected:
		is_end_turn_button_pressed_connected = true
		EventBus.end_turn_button_pressed.connect(_end_turn_button_pressed)
		ConsoleLog.SIGNAL(self,"end_turn_button_pressed","connected",1)

func disconnect_from_end_turn_button_pressed():
	if is_end_turn_button_pressed_connected:
		is_end_turn_button_pressed_connected = false
		EventBus.end_turn_button_pressed.disconnect(_end_turn_button_pressed)
		ConsoleLog.SIGNAL(self,"end_turn_button_pressed","disconnected",0)

func _end_turn_button_pressed(signal_key : int):
	skill_order_array = skill_order_array.filter(func(n): return n != null)
	for i : skill in skill_order_array:
		var iterator_ref_counter = i.get_reference_count()
		ConsoleLog.DEBUG(self,"iterator_ref_counter " + str(iterator_ref_counter))
		i.execute_skill()
	ConsoleLog.SIGNAL(self,"end_turn_button_pressed","processed",signal_key)
