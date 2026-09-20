extends Control

class_name team_formation_ui_element

@onready var team_captain_button: Button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/team_captain_button
@onready var pos_one_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/pos_one_button
@onready var pos_two_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/pos_two_button
@onready var pos_three_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/pos_three_button
@onready var pos_four_button: Button = $MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/pos_four_button
@onready var pos_five_button: Button = $MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/pos_five_button

func _ready() -> void:
	team_captain_button.text = TeamRoster.team_captain.unit_name
	pos_one_button.text = TeamRoster.combat_team[0].unit_name
	pos_two_button.text = TeamRoster.combat_team[1].unit_name
	pos_three_button.text = TeamRoster.combat_team[2].unit_name
	pos_four_button.text = TeamRoster.combat_team[3].unit_name
	pos_five_button.text = TeamRoster.combat_team[4].unit_name
	
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"set_current_button_focus","emit",new_signal_key)
	EventBus.set_current_button_focus.emit(team_captain_button,new_signal_key)
	
	team_captain_button.grab_focus.call_deferred()
