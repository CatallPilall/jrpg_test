extends Node2D

class_name combat_scene

@onready var ally_position_one : Node2D = $ally_position_one
@onready var enemy_position_one: Node2D = $enemy_position_one

var combat_hud_packed_scene : PackedScene = preload("res://scenes/UI_scenes/combat_hud.tscn")

var ally_unit_on_position_one : PackedScene = preload("res://scenes/unit_scenes/unit_brunhilde.tscn")

var ally_one : unit
var enemy_one : unit

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	var new_ally_one : unit = ally_unit_on_position_one.instantiate()
	ally_one = new_ally_one
	ally_position_one.add_child(ally_one)
	enemy_position_one.add_child(enemy_one)
	var new_combat_hud : Control = combat_hud_packed_scene.instantiate()
	var new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"load_hud_scene","emit",new_signal_key)
	EventBus.load_hud_scene.emit(new_combat_hud,new_signal_key)

func _on_ally_one_area_2d_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("right_click"):
		_unit_right_clicked(ally_one,viewport)

func _on_enemy_one_area_2d_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("right_click"):
		_unit_right_clicked(enemy_one,viewport)

func _unit_right_clicked(selected_unit : unit, viewport : Node):
	var mouse_position : Vector2 = viewport.get_mouse_position()
	ConsoleLog.INPUT("right_click","action_pressed",[mouse_position,selected_unit])
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"display_unit_info","emit",new_signal_key)
	EventBus.display_unit_info.emit(selected_unit,new_signal_key)
