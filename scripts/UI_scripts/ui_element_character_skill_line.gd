extends Control

class_name character_skill_line_ui

@onready var skill_one: Button = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/skill_one
@onready var skill_two: Button = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/skill_two
@onready var skill_three: Button = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/skill_three

@onready var level_one: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_one
@onready var level_two: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_two
@onready var level_three: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_three
@onready var level_four: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_four
@onready var level_five: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_five
@onready var level_six: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_six
@onready var level_seven: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_seven
@onready var level_eight: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_eight
@onready var level_nine: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_nine
@onready var level_ten: Button = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/level_ten

@onready var skill_line_name: Label = $MarginContainer/VBoxContainer/MarginContainer3/skill_line_name

var skill_one_icon_buffer : Texture
var skill_two_icon_buffer : Texture
var skill_three_icon_buffer : Texture

func _ready() -> void:
	skill_one.icon = skill_one_icon_buffer
	skill_two.icon = skill_two_icon_buffer
	skill_three.icon = skill_three_icon_buffer

func make_skill_line_ui_element(unit_skill_line : skill_line):
	var is_skill_one_open : bool = true
	var is_skill_two_open : bool = true
	var is_skill_three_open : bool = true
	
	for skill_in_skill_line : skill in unit_skill_line:
		if unit_skill_line.skill_line_level >= unit_skill_line.skill_line_bound_skill[skill_in_skill_line]:
			if is_skill_one_open:
				is_skill_one_open = false
				skill_one_icon_buffer = load(skill_in_skill_line.skill_icon_path)
			if is_skill_two_open:
				is_skill_two_open = false
				skill_two_icon_buffer = load(skill_in_skill_line.skill_icon_path)
			if is_skill_three_open:
				is_skill_three_open = false
				skill_three_icon_buffer = load(skill_in_skill_line.skill_icon_path)
	
	set_level_buttons(unit_skill_line.skill_line_level)
	
	skill_line_name.text = unit_skill_line.skill_line_name

func set_level_buttons(skill_line_level : int):
	if skill_line_level >= 1:
		level_one.button_pressed = true
	if skill_line_level >= 2:
		level_two.button_pressed = true
	if skill_line_level >= 3:
		level_three.button_pressed = true
	if skill_line_level >= 4:
		level_four.button_pressed = true
	if skill_line_level >= 5:
		level_five.button_pressed = true
	if skill_line_level >= 6:
		level_six.button_pressed = true
	if skill_line_level >= 7:
		level_seven.button_pressed = true
	if skill_line_level >= 8:
		level_eight.button_pressed = true
	if skill_line_level >= 9:
		level_nine.button_pressed = true
	if skill_line_level >= 10:
		level_ten.button_pressed = true
