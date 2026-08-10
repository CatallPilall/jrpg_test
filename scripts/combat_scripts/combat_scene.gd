extends Node2D

class_name combat_scene

@onready var ally_position_one : Node2D = $ally_position_one
@onready var enemy_position_one: Node2D = $enemy_position_one
@onready var enemy_position_two: Node2D = $enemy_position_two
@onready var enemy_position_three: Node2D = $enemy_position_three
@onready var enemy_position_four: Node2D = $enemy_position_four
@onready var enemy_position_five: Node2D = $enemy_position_five

@onready var camera_2d: Camera2D = $Camera2D

var combat_hud_packed_scene : PackedScene = preload("res://scenes/UI_scenes/combat_hud.tscn")

var is_remove_dead_unit_connected : bool = false

var ally_team : Array[unit]

var enemy_one : unit
var enemy_two : unit 
var enemy_three : unit
var enemy_four : unit
var enemy_five : unit

var combat_duration : int

var overworld_encounter : Node2D

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	
	camera_2d.make_current()
	
	copy_combat_team_locally()
	
	connect_to_remove_dead_unit()
	
	var new_ally_one_sprite = Sprite2D.new()
	new_ally_one_sprite.texture = load(ally_team[0].unit_sprite_path)
	ally_position_one.add_child(new_ally_one_sprite)
	
	load_enemy_sprites()
	
	var new_signal_key : int = EventBus.generate_signal_key()
	var new_combat_hud : Control = combat_hud_packed_scene.instantiate()
	new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"load_hud_scene","emit",new_signal_key)
	EventBus.load_hud_scene.emit(new_combat_hud,new_signal_key)

func load_enemy_sprites():
	if enemy_one:
		var new_enemy_one_sprite = Sprite2D.new()
		new_enemy_one_sprite.texture = load(enemy_one.unit_sprite_path)
		enemy_position_one.add_child(new_enemy_one_sprite)
	else:
		enemy_position_one.hide()
	if enemy_two:
		var new_enemy_two_sprite = Sprite2D.new()
		new_enemy_two_sprite.texture = load(enemy_two.unit_sprite_path)
		enemy_position_two.add_child(new_enemy_two_sprite)
	else:
		enemy_position_two.hide()
	if enemy_three:
		var new_enemy_three_sprite = Sprite2D.new()
		new_enemy_three_sprite.texture = load(enemy_three.unit_sprite_path)
		enemy_position_three.add_child(new_enemy_three_sprite)
	else:
		enemy_position_three.hide()
	if enemy_four:
		var new_enemy_four_sprite = Sprite2D.new()
		new_enemy_four_sprite.texture = load(enemy_four.unit_sprite_path)
		enemy_position_four.add_child(new_enemy_four_sprite)
	else:
		enemy_position_four.hide()
	if enemy_five:
		var new_enemy_five_sprite = Sprite2D.new()
		new_enemy_five_sprite.texture = load(enemy_five.unit_sprite_path)
		enemy_position_five.add_child(new_enemy_five_sprite)
	else:
		enemy_position_five.hide()

func connect_to_remove_dead_unit():
	if not is_remove_dead_unit_connected:
		is_remove_dead_unit_connected = true
		EventBus.remove_dead_unit.connect(_remove_dead_unit)
		ConsoleLog.SIGNAL(self,"remove_dead_unit","connected",1)

func disconnect_from_remove_dead_unit():
	if is_remove_dead_unit_connected:
		is_remove_dead_unit_connected = false
		EventBus.remove_dead_unit.disconnect(_remove_dead_unit)
		ConsoleLog.SIGNAL(self,"remove_dead_unit","disconnected",0)

func _remove_dead_unit(dead_unit : unit, signal_key : int):
	combat_duration -= 1
	match dead_unit:
		enemy_one:
			enemy_position_one.hide()
		enemy_two:
			enemy_position_two.hide()
		enemy_three:
			enemy_position_three.hide()
		enemy_four:
			enemy_position_four.hide()
		enemy_five:
			enemy_position_five.hide()
	
	if combat_duration <= 0:
		end_combat()
	
	ConsoleLog.SIGNAL(self,"remove_dead_unit","processed",signal_key)

func end_combat():
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"unload_combat_scene","emit",new_signal_key)
	EventBus.unload_combat_scene.emit(overworld_encounter,new_signal_key)
	new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"load_hud_scene","emit",new_signal_key)
	EventBus.load_hud_scene.emit(null,new_signal_key)

func copy_combat_team_locally():
	ally_team = TeamRoster.combat_team

func _on_ally_one_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,ally_team[0])

func _on_enemy_one_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,enemy_one)

func _unit_clicked(event: InputEvent, selected_unit : unit):
	if event.is_action_pressed("right_click"):
		_unit_right_clicked(selected_unit)
	if event.is_action_pressed("left_click"):
		_unit_left_clicked(selected_unit)

func _unit_right_clicked(selected_unit : unit):
	ConsoleLog.INPUT("right_click","action_pressed",[selected_unit])

func _unit_left_clicked(selected_unit : unit):
	ConsoleLog.INPUT("left_click","action_pressed",[selected_unit])
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"unit_targets_selected","emit",new_signal_key)
	var new_targets : Array[unit]
	new_targets.append(selected_unit)
	EventBus.unit_targets_selected.emit(new_targets,new_signal_key)

func _on_ally_one_area_2d_mouse_entered() -> void:
	_unit_hovered(ally_team[0])

func _on_enemy_one_area_2d_mouse_entered() -> void:
	_unit_hovered(enemy_one)

func _unit_hovered(hovered_unit : unit):
	ConsoleLog.INPUT("mouse_entered","mouse_movement",[hovered_unit])
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"display_unit_info","emit",new_signal_key)
	EventBus.display_unit_info.emit(hovered_unit,new_signal_key)


func _on_enemy_two_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,enemy_two)


func _on_enemy_two_area_2d_mouse_entered() -> void:
	_unit_hovered(enemy_two)


func _on_enemy_three_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,enemy_three)


func _on_enemy_three_area_2d_mouse_entered() -> void:
	_unit_hovered(enemy_three)


func _on_enemy_four_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,enemy_four)


func _on_enemy_four_area_2d_mouse_entered() -> void:
	_unit_hovered(enemy_four)


func _on_enemy_five_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,enemy_five)


func _on_enemy_five_area_2d_mouse_entered() -> void:
	_unit_hovered(enemy_five)
