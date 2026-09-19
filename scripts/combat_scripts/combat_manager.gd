extends Node

var related_functions_to_signals : Dictionary[Callable, Signal] = {
	_skill_button_pressed: EventBus.skill_button_pressed,
	_unit_targets_selected: EventBus.unit_targets_selected,
	_end_turn_button_pressed: EventBus.end_turn_button_pressed,
	_combat_hud_has_loaded: EventBus.combat_hud_has_loaded,
	_clean_up_skill: EventBus.clean_up_skill,
	_combat_state_changed_via_combat_hud: EventBus.combat_state_changed_via_combat_hud,
	_item_button_pressed: EventBus.item_button_pressed
}

var skill_dict : Dictionary[String,skill] = {
	"attack":preload("res://resources/skills/attack_skill/attack_skill.tres"),
	"fireball":preload("res://resources/skills/fireball_skill/fireball_skill.tres"),
	"exsanguinate":preload("res://resources/skills/exsanguinate_skill/exsanguinate_skill.tres"),
	"poison cloud":preload("res://resources/skills/poison_cloud_skill/poison_cloud_skill.tres"),
	"shock":preload("res://resources/skills/shock_skill/shock_skill.tres"),
	"bash":preload("res://resources/skills/bash_skill/bash_skill.tres"),
	"cleanse":preload("res://resources/skills/cleanse_skill/cleanse_skill.tres"),
	"power surge":preload("res://resources/skills/power_surge_skill/power_surge_skill.tres"),
	"strength leech":preload("res://resources/skills/life_leech_skill/strength_leech_skill.tres")
}

enum combat_state_machine {FIRST_CHARACTER,CHARACTER_SELECTED,SKILL_PENDING,SKILL_SELECTED,LAST_CHARACTER,ITEM_SELECTED}
var combat_state : combat_state_machine

var selected_unit_array_position : int
var selected_unit : unit

var combat_team_reference : Array[unit]

var selected_skill : skill
var selected_item : item

var skill_order_array : Array[skill]

var item_usage_array : Array[bool]


func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	EventBus.connect_functions_with_signals(self, related_functions_to_signals)
	store_combat_team_locally()
	combat_state = combat_state_machine.FIRST_CHARACTER


func _clean_up_skill(skill_to_clean : skill, signal_key : int):
	skill_order_array.erase(skill_to_clean)
	ConsoleLog.SIGNAL(self,"clean_up_skill","processed",signal_key)


func _combat_hud_has_loaded(signal_key : int):
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"new_selected_unit","emit",new_signal_key)
	EventBus.new_selected_unit.emit(selected_unit,new_signal_key)
	ConsoleLog.SIGNAL(self,"hud_scene_has_loaded","processed",signal_key)

func store_combat_team_locally():
	combat_team_reference = TeamRoster.combat_team
	for i in combat_team_reference.size():
		item_usage_array.append(false)
	selected_unit_array_position = 0
	new_unit_selected()

func new_unit_selected():
	selected_unit = combat_team_reference[selected_unit_array_position]
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"new_selected_unit","emit",new_signal_key)
	EventBus.new_selected_unit.emit(selected_unit,new_signal_key)

	new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"disable_item_button","emit",new_signal_key)
	EventBus.disable_item_button.emit(item_usage_array[selected_unit_array_position],new_signal_key)


func _skill_button_pressed(skill_name : String, signal_key : int):
	if skill_name == "skill":
		combat_state = combat_state_machine.SKILL_PENDING
		var new_skill_array : Array[String]
		for i in selected_unit.unit_skills:
			new_skill_array.append(i)
		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"make_combat_hud_skill_buttons","emit",new_signal_key)
		EventBus.make_combat_hud_skill_buttons.emit(new_skill_array, new_signal_key)
	elif skill_name == "item":
		combat_state = combat_state_machine.SKILL_PENDING
		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"make_combat_hud_item_buttons","emit",new_signal_key)
		EventBus.make_combat_hud_item_buttons.emit(new_signal_key)
	else:
		var new_skill : skill = skill_dict.get(skill_name).duplicate_deep(2)
		selected_skill = new_skill

		combat_state = combat_state_machine.SKILL_SELECTED
		ConsoleLog.INFO(self,["selected_skill","selected_unit"],[selected_skill,selected_unit])

		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"apply_skill_targeting","emit",new_signal_key)
		EventBus.apply_skill_targeting.emit(selected_skill.primary_skill_targeting,selected_skill.secondary_skill_targeting,selected_unit,new_signal_key)

		ConsoleLog.SIGNAL(self,"skill_button_pressed","processed",signal_key)


func _item_button_pressed(pressed_item : item, signal_key : int):
	selected_item = pressed_item
	var item_skill : skill = selected_item.item_skill

	combat_state = combat_state_machine.ITEM_SELECTED
	ConsoleLog.INFO(self,["selected_skill","selected_unit"],[item_skill,selected_unit])

	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"apply_skill_targeting","emit",new_signal_key)
	EventBus.apply_skill_targeting.emit(item_skill.skill_targeting,new_signal_key)

	ConsoleLog.SIGNAL(self,"item_button_pressed","processed",signal_key)


func _unit_targets_selected(selected_targets : Array[unit], secondary_targets : Array[unit], signal_key : int):
	ConsoleLog.DEBUG(self,"_unit_targets_selected caught secondary_targets: " + str(secondary_targets))
	if selected_skill:
		selected_skill.set_caster_and_targets(selected_unit,selected_targets, secondary_targets)
		queue_skill(selected_skill)
		selected_skill = null
		cycle_ally_unit()
	if selected_item:
		item_usage_array[selected_unit_array_position] = true
		selected_item.item_skill.set_caster_and_targets(selected_unit,selected_targets, secondary_targets)
		selected_item.item_skill.execute_skill()
		TeamRoster.consumables.erase(selected_item)
		selected_item = null

		if selected_unit_array_position == 0:
			combat_state = combat_state_machine.FIRST_CHARACTER
		else:
			combat_state = combat_state_machine.CHARACTER_SELECTED

		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","emit",new_signal_key)
		EventBus.remove_combat_hud_skill_buttons.emit(new_signal_key)

		new_signal_key = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"disable_item_button","emit",new_signal_key)
		EventBus.disable_item_button.emit(true,new_signal_key)

	ConsoleLog.SIGNAL(self,"unit_targets_selected","processed",signal_key)

func cycle_ally_unit():
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","emit",new_signal_key)
	EventBus.remove_combat_hud_skill_buttons.emit(new_signal_key)

	new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"apply_skill_targeting","emit",new_signal_key)
	EventBus.apply_skill_targeting.emit(skill.enum_skill_targeting.NONE,skill.enum_skill_targeting.NONE,null,new_signal_key)

	if selected_unit_array_position == TeamRoster.combat_team.size()-1:
		new_signal_key = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"disable_combat_hud_actions","emit",new_signal_key)
		EventBus.disable_combat_hud_actions.emit(new_signal_key)

		combat_state = combat_state_machine.LAST_CHARACTER
	else:
		selected_unit_array_position += 1
		new_unit_selected()
		combat_state = combat_state_machine.CHARACTER_SELECTED

func queue_skill(skill_to_queue : skill):
	skill_order_array.append(skill_to_queue)
	skill_order_array.sort_custom(sort_skill_order_array)
	ConsoleLog.INFO(self,["skill_order_array"],[skill_order_array])

func sort_skill_order_array(a : skill, b : skill):
	if a.total_speed > b.total_speed:
		return true
	return false


func _end_turn_button_pressed(signal_key : int):
	skill_order_array = skill_order_array.filter(func(n): return n != null)
	for i : skill in skill_order_array:
		i.execute_skill()

	for i in item_usage_array:
		i = false

	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"combat_turn_ended","emit",new_signal_key)
	EventBus.combat_turn_ended.emit(new_signal_key)

	start_new_turn()
	ConsoleLog.SIGNAL(self,"end_turn_button_pressed","processed",signal_key)

func start_new_turn():
	selected_unit_array_position = 0
	combat_state = combat_state_machine.FIRST_CHARACTER
	new_unit_selected()
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"enable_combat_hud_actions","emit",new_signal_key)
	EventBus.enable_combat_hud_actions.emit(new_signal_key)

	# HÄÄÄÄÄÄ ?????????
	# nirgends connected, why do we need it?
	# new_signal_key = EventBus.generate_signal_key()
	# ConsoleLog.SIGNAL(self,"new_turn","emit",new_signal_key)
	# EventBus.new_turn.emit(new_signal_key)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		undo_last_action()

func undo_last_action():
	match combat_state:
		combat_state_machine.FIRST_CHARACTER:
			return
		combat_state_machine.SKILL_SELECTED:
			selected_skill = null
			if selected_unit_array_position == 0:
				combat_state = combat_state_machine.FIRST_CHARACTER
			else:
				combat_state = combat_state_machine.CHARACTER_SELECTED

			var new_signal_key :int = EventBus.generate_signal_key()
			ConsoleLog.SIGNAL(self,"apply_skill_targeting","emit",new_signal_key)
			EventBus.apply_skill_targeting.emit(skill.enum_skill_targeting.NONE,skill.enum_skill_targeting.NONE,null,new_signal_key)

		combat_state_machine.CHARACTER_SELECTED:
			selected_unit_array_position -= 1
			selected_skill = skill_order_array.pop_back()
			new_unit_selected()
			combat_state = combat_state_machine.SKILL_SELECTED

			var new_signal_key :int = EventBus.generate_signal_key()
			ConsoleLog.SIGNAL(self,"apply_skill_targeting","emit",new_signal_key)
			EventBus.apply_skill_targeting.emit(selected_skill.primary_skill_targeting,selected_skill.secondary_skill_targeting,null,new_signal_key)

		combat_state_machine.LAST_CHARACTER:
			selected_skill = skill_order_array.pop_back()
			var new_signal_key : int = EventBus.generate_signal_key()
			ConsoleLog.SIGNAL(self,"enable_combat_hud_actions","emit",new_signal_key)
			EventBus.enable_combat_hud_actions.emit(new_signal_key)
			combat_state = combat_state_machine.SKILL_SELECTED
		combat_state_machine.SKILL_PENDING:
			var new_signal_key : int = EventBus.generate_signal_key()
			ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","emit",new_signal_key)
			EventBus.remove_combat_hud_skill_buttons.emit(new_signal_key)
			if selected_unit_array_position == 0:
				combat_state = combat_state_machine.FIRST_CHARACTER
			else:
				combat_state = combat_state_machine.CHARACTER_SELECTED
		combat_state_machine.ITEM_SELECTED:
			var new_signal_key : int = EventBus.generate_signal_key()
			ConsoleLog.SIGNAL(self,"remove_combat_hud_skill_buttons","emit",new_signal_key)
			EventBus.remove_combat_hud_skill_buttons.emit(new_signal_key)

			new_signal_key = EventBus.generate_signal_key()
			ConsoleLog.SIGNAL(self,"apply_skill_targeting","emit",new_signal_key)
			EventBus.apply_skill_targeting.emit(selected_item.item_skill.primary_skill_targeting,selected_item.item_skill.secondary_skill_targeting,null,new_signal_key)

			selected_item = null

			if selected_unit_array_position == 0:
				combat_state = combat_state_machine.FIRST_CHARACTER
			else:
				combat_state = combat_state_machine.CHARACTER_SELECTED

	ConsoleLog.INFO(self,["selected_character","selected_skill","state_machine","skill_array"],[selected_unit,selected_skill,combat_state,skill_order_array])


func _combat_state_changed_via_combat_hud(signal_key : int):
	if selected_unit_array_position == 0:
		combat_state = combat_state_machine.FIRST_CHARACTER
	else:
		combat_state = combat_state_machine.CHARACTER_SELECTED
	ConsoleLog.SIGNAL(self,"combat_state_changed_via_combat_hud","processed",signal_key)
