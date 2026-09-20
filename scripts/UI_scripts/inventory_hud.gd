extends Control

@onready var exit_button: Button = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/exit_button
@onready var formation_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/formation_button
@onready var item_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/item_button
@onready var logbook_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/logbook_button
@onready var skill_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/skill_button

@onready var select_container: VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer2/select_container
@onready var info_container: RichTextLabel = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer3/info_container

@onready var character_one_button: Button = $MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/front_row_container/MarginContainer/character_one_button
@onready var character_two_button: Button = $MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/front_row_container/MarginContainer2/character_two_button
@onready var character_three_button: Button = $MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/front_row_container/MarginContainer3/character_three_button
@onready var character_four_button: Button = $MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/MarginContainer2/back_row_container/MarginContainer/character_four_button
@onready var character_five_button: Button = $MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/MarginContainer2/back_row_container/MarginContainer2/character_five_button


@onready var character_button : PackedScene = preload("res://scenes/UI_scenes/ui_element_character_button.tscn")
@onready var team_formation : PackedScene = preload("res://scenes/UI_scenes/ui_element_team_formation.tscn")

var is_set_current_button_focus_connected : bool = false

enum enum_button_neighbor {UP,DOWN,LEFT,RIGHT}

var dummy_buttons_array : Array[String] = ["Button 1","Button 2","Button 3","Button 4"]

var return_chain : Array[Button]
var undo_containers : bool = false

var current_button_focus : Button
#---------------------------------------------------------------------------------
var brunhilde_unit : unit = preload("res://resources/units/brunhilde_unit.tres")
var casandra_unit : unit = preload("res://resources/units/casandra_unit.tres")
var derek_uit : unit = preload("res://resources/units/derek_unit.tres")
var karion_unit : unit = preload("res://resources/units/karion_unit.tres")
var ungor_unit : unit = preload("res://resources/units/ungor_unit.tres")
var small_healing_potion : item = preload("res://resources/items/small_healing_potion.tres")
var med_kit : item = preload("res://resources/items/med_kit.tres")
#---------------------------------------------------------------------------------
func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	#--------------------------------------------------------
	TeamRoster.put_unit_into_combat_team(brunhilde_unit)
	TeamRoster.put_unit_into_combat_team(casandra_unit)
	TeamRoster.put_unit_into_combat_team(derek_uit)
	TeamRoster.put_unit_into_combat_team(karion_unit)
	TeamRoster.put_unit_into_combat_team(ungor_unit)
	TeamRoster.put_item_into_inventory(small_healing_potion)
	TeamRoster.put_item_into_inventory(med_kit)
	#---------------------------------------------------------
	current_button_focus = item_button
	item_button.grab_focus.call_deferred()
	return_chain.append(exit_button)
	fill_character_container()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("control_return"):
		ConsoleLog.INPUT("control_return","is_action_pressed",[])
		return_one_step()
	if event.is_action_pressed("control_up"):
		ConsoleLog.INPUT("control_up","is_action_pressed",[])
		cycle_buttons_through_neighbors(enum_button_neighbor.UP)
	if event.is_action_pressed("control_down"):
		ConsoleLog.INPUT("control_down","is_action_pressed",[])
		cycle_buttons_through_neighbors(enum_button_neighbor.DOWN)
	if event.is_action_pressed("control_right"):
		ConsoleLog.INPUT("control_down","is_action_pressed",[])
		cycle_buttons_through_neighbors(enum_button_neighbor.RIGHT)
	if event.is_action_pressed("control_left"):
		ConsoleLog.INPUT("control_down","is_action_pressed",[])
		cycle_buttons_through_neighbors(enum_button_neighbor.LEFT)
	if event.is_action_pressed("control_confirm"):
		ConsoleLog.INPUT("control_confirm","is_action_pressed",[])
		confirm_button_input()

func confirm_button_input():
	current_button_focus.pressed.emit()
	current_button_focus.toggled.emit(true)

func return_one_step():
	if return_chain.is_empty():
		queue_free()
	else:
		current_button_focus = return_chain.pop_back()
		current_button_focus.grab_focus.call_deferred()
		current_button_focus.set_pressed_no_signal(false)
	
	if undo_containers:
		for cursor : Control in select_container.get_children():
			cursor.queue_free()
		info_container.text = ""
		undo_containers = false

func cycle_buttons_through_neighbors(button_neighbor : enum_button_neighbor):
	var local_button : Button = null
	var local_path : NodePath
	
	match button_neighbor:
		enum_button_neighbor.UP:
			if current_button_focus.focus_neighbor_top:
				local_path = current_button_focus.focus_neighbor_top
		enum_button_neighbor.DOWN:
			if current_button_focus.focus_neighbor_bottom:
				local_path = current_button_focus.focus_neighbor_bottom
		enum_button_neighbor.LEFT:
			if current_button_focus.focus_neighbor_left:
				local_path = current_button_focus.focus_neighbor_left
		enum_button_neighbor.RIGHT:
			if current_button_focus.focus_neighbor_right:
				local_path = current_button_focus.focus_neighbor_right
	
	if local_path:
		local_button = current_button_focus.get_node(local_path)
		local_button.grab_focus.call_deferred()
		current_button_focus = local_button

func fill_select_container(selected_array : Array):
	var prev_button : Button = null
	var is_first_button : bool = true
	var first_button : Button = null
	var is_last_button : bool = false
	
	for cursor in selected_array:
	
		if cursor == selected_array.back():
			is_last_button = true
		
		var new_button : Button = Button.new()
		if cursor is quest:
			new_button.text = cursor.quest_name
			new_button.focus_entered.connect(_fill_info_container.bind(cursor.quest_description))
		
		if cursor is item:
			new_button.text = cursor.item_name
			new_button.focus_entered.connect(_fill_info_container.bind(cursor.item_description))
		
		select_container.add_child(new_button)
		ConsoleLog.INFO(self,["new_button","text","path"],[new_button,cursor,new_button.get_path()])
		if is_first_button:
			is_first_button = false
			first_button = new_button
			current_button_focus = new_button
			current_button_focus.grab_focus.call_deferred()
		else:
			new_button.set_focus_neighbor(SIDE_TOP,prev_button.get_path())
			
			if is_last_button:
				new_button.set_focus_neighbor(SIDE_BOTTOM, first_button.get_path())
				first_button.set_focus_neighbor(SIDE_TOP, new_button.get_path())
			
			prev_button.set_focus_neighbor(SIDE_BOTTOM, new_button.get_path())
		prev_button = new_button

func fill_character_container():
	if TeamRoster.combat_team[0]:
		var new_button : character_button_ui = character_button.instantiate()
		new_button.make_character_ui_element(TeamRoster.combat_team[0])
		character_one_button.add_child.call_deferred(new_button)
	if TeamRoster.combat_team[1]:
		var new_button : character_button_ui = character_button.instantiate()
		new_button.make_character_ui_element(TeamRoster.combat_team[1])
		character_two_button.add_child.call_deferred(new_button)
	if TeamRoster.combat_team[2]:
		var new_button : character_button_ui = character_button.instantiate()
		new_button.make_character_ui_element(TeamRoster.combat_team[2])
		character_three_button.add_child.call_deferred(new_button)
	if TeamRoster.combat_team[3]:
		var new_button : character_button_ui = character_button.instantiate()
		new_button.make_character_ui_element(TeamRoster.combat_team[3])
		character_four_button.add_child.call_deferred(new_button)
	if TeamRoster.combat_team[4]:
		var new_button : character_button_ui = character_button.instantiate()
		new_button.make_character_ui_element(TeamRoster.combat_team[4])
		character_five_button.add_child.call_deferred(new_button)

func select_unit_roster():
	current_button_focus = character_one_button
	character_one_button.grab_focus.call_deferred()

func make_formation():
	var new_formation : team_formation_ui_element = team_formation.instantiate()
	select_container.add_child.call_deferred(new_formation)
	connect_to_set_current_button_focus()

func connect_to_set_current_button_focus():
	if not is_set_current_button_focus_connected:
		is_set_current_button_focus_connected = true
		EventBus.set_current_button_focus.connect(_set_current_button_focus)
		ConsoleLog.SIGNAL(self,"set_current_button_focus","connected",1)

func disconnect_from_set_current_button_focus():
	if is_set_current_button_focus_connected:
		is_set_current_button_focus_connected = false
		EventBus.set_current_button_focus.disconnect(_set_current_button_focus)
		ConsoleLog.SIGNAL(self,"set_current_button_focus","disconnected",0)

func _set_current_button_focus(new_button_focus : Button, signal_key : int):
	current_button_focus = new_button_focus
	ConsoleLog.SIGNAL(self,"set_current_button_focus","processed",signal_key)

func _fill_info_container(description : String):
	info_container.text = description

func _on_item_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		undo_containers = true
		return_chain.append(item_button)
		fill_select_container(TeamRoster.consumables)
		item_button.set_pressed_no_signal(true)

func _on_logbook_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		undo_containers = true
		return_chain.append(logbook_button)
		fill_select_container(TeamRoster.logbook)
		logbook_button.set_pressed_no_signal(true)

func _on_exit_button_pressed() -> void:
	queue_free()

func _on_skill_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		undo_containers = true
		return_chain.append(skill_button)
		select_unit_roster()
		skill_button.set_pressed_no_signal(true)

func _on_formation_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		undo_containers = true
		return_chain.append(formation_button)
		make_formation()
		formation_button.set_pressed_no_signal(true)
