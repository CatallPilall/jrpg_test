extends Node2D

@export var world_encounter : encounter

@onready var sprite_2d: Sprite2D = $Sprite2D

var combat_scene_packed_scene : PackedScene = preload("res://scenes/combat_scenes/combat_scene.tscn")

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	
	sprite_2d.texture = load(world_encounter.encounter_sprite_location)

func _on_area_2d_area_entered(_area: Area2D) -> void:
	var new_combat_scene : combat_scene = combat_scene_packed_scene.instantiate()
	
	_make_combat_scene(new_combat_scene)
	
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"load_combat_scene","emit",new_signal_key)
	EventBus.load_combat_scene.emit(new_combat_scene,new_signal_key)

func _make_combat_scene(new_combat_scene : combat_scene):
	if world_encounter.enemy_one:
		new_combat_scene.enemy_one = world_encounter.enemy_one.duplicate()
	if world_encounter.enemy_two:
		new_combat_scene.enemy_two = world_encounter.enemy_two.duplicate()
	if world_encounter.enemy_three:
		new_combat_scene.enemy_three = world_encounter.enemy_three.duplicate()
	if world_encounter.enemy_four:
		new_combat_scene.enemy_four = world_encounter.enemy_four.duplicate()
	if world_encounter.enemy_five:
		new_combat_scene.enemy_five = world_encounter.enemy_five.duplicate()
	new_combat_scene.combat_duration = world_encounter.end_condition
	new_combat_scene.overworld_encounter = self
