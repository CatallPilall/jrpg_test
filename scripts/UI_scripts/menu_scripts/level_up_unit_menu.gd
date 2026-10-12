extends BaseUI

class_name level_up_ui

@onready var skill_lines_container: VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/skill_lines_container

var ui_element_character_skill_line : PackedScene = preload("res://scenes/UI_scenes/ui_element_character_skill_line.tscn")

var selected_unit_reference : unit

func _ready() -> void:
	if selected_unit_reference:
		for skill_lines_in_unit : skill_line in selected_unit_reference.unit_skill_lines:
			var new_character_skill_line : character_skill_line_ui = ui_element_character_skill_line.instantiate()
			new_character_skill_line.make_skill_line_ui_element(skill_lines_in_unit)
			skill_lines_container.add_child.call_deferred(new_character_skill_line)


func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	if called_node == self:
		ConsoleLog.DEBUG("HEHEO AUFGERUFEN IN LEVEL_UP_UI PREPARE_SCENE")
		if arguments:
			if arguments[0] is unit:
				selected_unit_reference = arguments[0]
			else:
				ConsoleLog.ERROR("wrong type, is: " + str(arguments[0] + " needs to be unit"))
		
		ConsoleLog.SIGNAL(EventBus.prepare_scene,"processed",signal_key)


func _on_exit_button_pressed() -> void:
	SceneLoader.process_scene("character_level_menu", [], SceneLoader.SCENE_PROCESS_TYPE.DEACTIVATE)
	SceneLoader.process_scene("character_level_menu", [], SceneLoader.SCENE_PROCESS_TYPE.UNLOAD)
