extends Node2D

@onready var player_spawn_position: Node2D = $player_spawn_position


var player_character_packed_scene : PackedScene = preload("res://scenes/player_scenes/player_character.tscn")
var player_character : CharacterBody2D

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	player_character = player_character_packed_scene.instantiate()
	player_spawn_position.add_child(player_character)
