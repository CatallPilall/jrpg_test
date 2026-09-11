extends Control

class_name character_button_ui

@onready var character_portrait: TextureRect = $MarginContainer/HBoxContainer/MarginContainer/character_portrait
@onready var character_name: Label = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/character_name
@onready var character_skillpoints: Label = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/MarginContainer/character_skillpoints
@onready var character_status: Label = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/MarginContainer2/character_status

var character_portrait_buffer : Texture
var character_name_buffer : String
var character_skillpoints_buffer : String
var character_status_buffer : String

func _ready() -> void:
	#character_portrait.texture = character_portrait_buffer
	character_name.text = character_name_buffer
	character_skillpoints.text = character_skillpoints_buffer
	character_status.text = character_status_buffer

func make_character_ui_element(character : unit):
	#var portrait_path : String = character.unit_sprite_path
	#character_portrait_buffer = load(portrait_path)
	character_name_buffer = character.unit_name
	character_status_buffer = str(character.base_stats.get("health_points")) + " / " + str(character.base_stats.get("health_points"))
	character_skillpoints_buffer = str(character.unit_skillpoints)
