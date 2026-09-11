extends Node2D

class_name combat_scene

@onready var ally_position_one : Node2D = $ally_position_one
@onready var ally_position_two: Node2D = $ally_position_two
@onready var ally_position_three: Node2D = $ally_position_three
@onready var ally_position_four: Node2D = $ally_position_four
@onready var ally_position_five: Node2D = $ally_position_five

@onready var enemy_position_one: Node2D = $enemy_position_one
@onready var enemy_position_two: Node2D = $enemy_position_two
@onready var enemy_position_three: Node2D = $enemy_position_three
@onready var enemy_position_four: Node2D = $enemy_position_four
@onready var enemy_position_five: Node2D = $enemy_position_five

@onready var ally_one_area_2d: Area2D = $ally_position_one/ally_one_Area2D
@onready var ally_two_area_2d: Area2D = $ally_position_two/ally_two_Area2D
@onready var ally_three_area_2d: Area2D = $ally_position_three/ally_three_Area2D
@onready var ally_four_area_2d: Area2D = $ally_position_four/ally_four_Area2D
@onready var ally_five_area_2d: Area2D = $ally_position_five/ally_five_Area2D

@onready var enemy_one_area_2d: Area2D = $enemy_position_one/enemy_one_Area2D
@onready var enemy_two_area_2d: Area2D = $enemy_position_two/enemy_two_Area2D
@onready var enemy_three_area_2d: Area2D = $enemy_position_three/enemy_three_Area2D
@onready var enemy_four_area_2d: Area2D = $enemy_position_four/enemy_four_Area2D
@onready var enemy_five_area_2d: Area2D = $enemy_position_five/enemy_five_Area2D

@onready var enemy_team_area_2d: Area2D = $enemy_team_Area2D
@onready var ally_team_area_2d: Area2D = $ally_team_Area2D
@onready var enemy_front_line_area_2d: Area2D = $enemy_front_line_Area2D
@onready var enemy_back_line_area_2d: Area2D = $enemy_back_line_Area2D
@onready var ally_front_line_area_2d: Area2D = $ally_front_line_Area2D
@onready var ally_back_line_area_2d: Area2D = $ally_back_line_Area2D
@onready var enemy_left_flank_area_2d: Area2D = $enemy_left_flank_Area2D
@onready var enemy_right_flank_area_2d: Area2D = $enemy_right_flank_Area2D
@onready var ally_left_flank_area_2d: Area2D = $ally_left_flank_Area2D
@onready var ally_right_flank_area_2d: Area2D = $ally_right_flank_Area2D
@onready var enemy_area_one_area_2d: Area2D = $enemy_area_one_Area2D
@onready var enemy_area_two_area_2d: Area2D = $enemy_area_two_Area2D
@onready var enemy_area_three_area_2d: Area2D = $enemy_area_three_Area2D
@onready var ally_area_one_area_2d: Area2D = $ally_area_one_Area2D
@onready var ally_area_two_area_2d: Area2D = $ally_area_two_Area2D
@onready var ally_area_three_area_2d: Area2D = $ally_area_three_Area2D


@onready var camera_2d: Camera2D = $Camera2D

var combat_hud_packed_scene : PackedScene = preload("res://scenes/UI_scenes/combat_hud.tscn")

var is_remove_dead_unit_connected : bool = false
var is_apply_skill_targeting_connected : bool = false

var ally_team : Array[unit]

var secondary_targets : Array[unit]

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
	connect_to_apply_skill_targeting()
	
	load_ally_sprites()
	load_enemy_sprites()
	
	_apply_skill_targeting(skill.enum_skill_targeting.NONE,skill.enum_skill_targeting.NONE,null,2)
	
	var new_signal_key : int = EventBus.generate_signal_key()
	var new_combat_hud : Control = combat_hud_packed_scene.instantiate()
	new_signal_key = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"load_hud_scene","emit",new_signal_key)
	EventBus.load_hud_scene.emit(new_combat_hud,new_signal_key)

func connect_to_apply_skill_targeting():
	if not is_apply_skill_targeting_connected:
		is_apply_skill_targeting_connected = true
		EventBus.apply_skill_targeting.connect(_apply_skill_targeting)
		ConsoleLog.SIGNAL(self,"apply_skill_targeting","connected",1)

func disconnect_from_apply_skill_targeting():
	if is_apply_skill_targeting_connected:
		is_apply_skill_targeting_connected = false
		EventBus.apply_skill_targeting.disconnect(_apply_skill_targeting)
		ConsoleLog.SIGNAL(self,"apply_skill_targeting","disconnected",0)

func _apply_skill_targeting(primary_skill_targeting : skill.enum_skill_targeting, secondary_skill_targeting : skill.enum_skill_targeting, casting_unit : unit, signal_key : int):
	ally_one_area_2d.show()
	ally_two_area_2d.show()
	ally_three_area_2d.show()
	ally_four_area_2d.show()
	ally_five_area_2d.show()
	
	enemy_one_area_2d.show()
	enemy_two_area_2d.show()
	enemy_three_area_2d.show()
	enemy_four_area_2d.show()
	enemy_five_area_2d.show()
	
	enemy_team_area_2d.hide()
	ally_team_area_2d.hide()
	enemy_front_line_area_2d.hide()
	enemy_back_line_area_2d.hide()
	ally_front_line_area_2d.hide()
	ally_back_line_area_2d.hide()
	enemy_left_flank_area_2d.hide()
	enemy_right_flank_area_2d.hide()
	ally_left_flank_area_2d.hide()
	ally_right_flank_area_2d.hide()
	enemy_area_one_area_2d.hide()
	enemy_area_two_area_2d.hide()
	enemy_area_three_area_2d.hide()
	ally_area_one_area_2d.hide()
	ally_area_two_area_2d.hide()
	ally_area_three_area_2d.hide()
	
	secondary_targets.clear()
	
	match primary_skill_targeting:
		skill.enum_skill_targeting.NONE:
			return
		skill.enum_skill_targeting.SELF:
			hide_individual_area_2d()
			if ally_team[0] == casting_unit:
				ally_one_area_2d.show()
			elif ally_team[1] == casting_unit:
				ally_two_area_2d.show()
			elif ally_team[2] == casting_unit:
				ally_three_area_2d.show()
			elif ally_team[3] == casting_unit:
				ally_four_area_2d.show()
			elif ally_team[4] == casting_unit:
				ally_five_area_2d.show()
		skill.enum_skill_targeting.SINGLE_ENEMY:
			ally_one_area_2d.hide()
			ally_two_area_2d.hide()
			ally_three_area_2d.hide()
			ally_four_area_2d.hide()
			ally_five_area_2d.hide()
		skill.enum_skill_targeting.TEAM_ENEMY:
			hide_individual_area_2d()
			enemy_team_area_2d.show()
		skill.enum_skill_targeting.FRONT_ENEMY:
			hide_individual_area_2d()
			enemy_front_line_area_2d.show()
		skill.enum_skill_targeting.BACK_ENEMY:
			hide_individual_area_2d()
			enemy_back_line_area_2d.show()
		skill.enum_skill_targeting.LEFT_ENEMY:
			hide_individual_area_2d()
			enemy_left_flank_area_2d.show()
		skill.enum_skill_targeting.RIGHT_ENEMY:
			hide_individual_area_2d()
			enemy_right_flank_area_2d.show()
		skill.enum_skill_targeting.AREA_ENEMY:
			hide_individual_area_2d()
			enemy_area_one_area_2d.show()
			enemy_area_two_area_2d.show()
			enemy_area_three_area_2d.show()
		skill.enum_skill_targeting.SINGLE_ALLY:
			enemy_one_area_2d.hide()
			enemy_two_area_2d.hide()
			enemy_three_area_2d.hide()
			enemy_four_area_2d.hide()
			enemy_five_area_2d.hide()
		skill.enum_skill_targeting.TEAM_ALLY:
			hide_individual_area_2d()
			ally_team_area_2d.show()
		skill.enum_skill_targeting.FRONT_ALLY:
			hide_individual_area_2d()
			ally_front_line_area_2d.show()
		skill.enum_skill_targeting.BACK_ALLY:
			hide_individual_area_2d()
			ally_back_line_area_2d.show()
		skill.enum_skill_targeting.LEFT_ALLY:
			hide_individual_area_2d()
			ally_left_flank_area_2d.show()
		skill.enum_skill_targeting.RIGHT_ALLY:
			hide_individual_area_2d()
			ally_right_flank_area_2d.show()
		skill.enum_skill_targeting.AREA_ALLY:
			hide_individual_area_2d()
			ally_area_one_area_2d.show()
			ally_area_two_area_2d.show()
			ally_area_three_area_2d.show()
	
	set_secondary_targets(secondary_skill_targeting, casting_unit)
	
	ConsoleLog.SIGNAL(self,"apply_skill_targeting","processed",signal_key)

func hide_individual_area_2d():
	ally_one_area_2d.hide()
	ally_two_area_2d.hide()
	ally_three_area_2d.hide()
	ally_four_area_2d.hide()
	ally_five_area_2d.hide()
	
	enemy_one_area_2d.hide()
	enemy_two_area_2d.hide()
	enemy_three_area_2d.hide()
	enemy_four_area_2d.hide()
	enemy_five_area_2d.hide()

func set_secondary_targets(skill_targeting : skill.enum_skill_targeting, caster : unit):
	match skill_targeting:
		skill.enum_skill_targeting.NONE:
			return
		skill.enum_skill_targeting.SELF:
			secondary_targets.append(caster)
		skill.enum_skill_targeting.TEAM_ENEMY:
			append_units_into_secondary_targeting([enemy_one,enemy_two,enemy_three,enemy_four,enemy_five])
		skill.enum_skill_targeting.FRONT_ENEMY:
			append_units_into_secondary_targeting([enemy_one,enemy_two,enemy_three])
		skill.enum_skill_targeting.BACK_ENEMY:
			append_units_into_secondary_targeting([enemy_four,enemy_five])
		skill.enum_skill_targeting.LEFT_ENEMY:
			append_units_into_secondary_targeting([enemy_one,enemy_four])
		skill.enum_skill_targeting.RIGHT_ENEMY:
			append_units_into_secondary_targeting([enemy_three,enemy_five])
		skill.enum_skill_targeting.TEAM_ALLY:
			append_units_into_secondary_targeting(ally_team)
		skill.enum_skill_targeting.FRONT_ALLY:
			append_units_into_secondary_targeting([ally_team[0],ally_team[1],ally_team[2]])
		skill.enum_skill_targeting.BACK_ALLY:
			append_units_into_secondary_targeting([ally_team[3],ally_team[4]])
		skill.enum_skill_targeting.LEFT_ALLY:
			append_units_into_secondary_targeting([ally_team[0],ally_team[3]])
		skill.enum_skill_targeting.RIGHT_ALLY:
			append_units_into_secondary_targeting([ally_team[2],ally_team[4]])

func append_units_into_secondary_targeting(targeted_units : Array[unit]):
	for selected_unit in targeted_units:
		if selected_unit == ally_team[0]:
			if ally_one_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == ally_team[1]:
			if ally_two_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == ally_team[2]:
			if ally_three_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == ally_team[3]:
			if ally_four_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == ally_team[4]:
			if ally_five_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == enemy_one:
			if enemy_one_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == enemy_two:
			if enemy_two_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == enemy_three:
			if enemy_three_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == enemy_four:
			if enemy_four_area_2d.visible:
				secondary_targets.append(selected_unit)
		if selected_unit == enemy_five:
			if enemy_five_area_2d.visible:
				secondary_targets.append(selected_unit)

func load_ally_sprites():
	if ally_team[0]:
		var new_ally_one_sprite = Sprite2D.new()
		new_ally_one_sprite.texture = load(ally_team[0].unit_sprite_path)
		ally_position_one.add_child(new_ally_one_sprite)
	else:
		ally_position_one.hide()
	if ally_team[1]:
		var new_ally_two_sprite = Sprite2D.new()
		new_ally_two_sprite.texture = load(ally_team[1].unit_sprite_path)
		ally_position_two.add_child(new_ally_two_sprite)
	else:
		ally_position_two.hide()
	if ally_team[2]:
		var new_ally_three_sprite = Sprite2D.new()
		new_ally_three_sprite.texture = load(ally_team[2].unit_sprite_path)
		ally_position_three.add_child(new_ally_three_sprite)
	else:
		ally_position_three.hide()
	if ally_team[3]:
		var new_ally_four_sprite = Sprite2D.new()
		new_ally_four_sprite.texture = load(ally_team[3].unit_sprite_path)
		ally_position_four.add_child(new_ally_four_sprite)
	else:
		ally_position_four.hide()
	if ally_team[4]:
		var new_ally_five_sprite = Sprite2D.new()
		new_ally_five_sprite.texture = load(ally_team[4].unit_sprite_path)
		ally_position_five.add_child(new_ally_five_sprite)
	else:
		ally_position_five.hide()

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
	ConsoleLog.DEBUG(self,"_unit_left_clicked throws secondary_targets: " + str(secondary_targets))
	var new_targets : Array[unit]
	new_targets.append(selected_unit)
	EventBus.unit_targets_selected.emit(new_targets,secondary_targets,new_signal_key)

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


func _on_ally_two_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,ally_team[1])


func _on_ally_two_area_2d_mouse_entered() -> void:
	_unit_hovered(ally_team[1])


func _on_ally_three_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,ally_team[2])


func _on_ally_three_area_2d_mouse_entered() -> void:
	_unit_hovered(ally_team[2])


func _on_ally_four_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,ally_team[3])


func _on_ally_four_area_2d_mouse_entered() -> void:
	_unit_hovered(ally_team[3])


func _on_ally_five_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_unit_clicked(event,ally_team[4])


func _on_ally_five_area_2d_mouse_entered() -> void:
	_unit_hovered(ally_team[4])

func interpret_complex_targeting(targeted_units : Array[unit]):
	var new_targets : Array[unit]
	for selected_unit in targeted_units:
		if selected_unit == ally_team[0]:
			if ally_position_one.visible:
				new_targets.append(selected_unit)
		if selected_unit == ally_team[1]:
			if ally_position_two.visible:
				new_targets.append(selected_unit)
		if selected_unit == ally_team[2]:
			if ally_position_three.visible:
				new_targets.append(selected_unit)
		if selected_unit == ally_team[3]:
			if ally_position_four.visible:
				new_targets.append(selected_unit)
		if selected_unit == ally_team[4]:
			if ally_position_five.visible:
				new_targets.append(selected_unit)
		if selected_unit == enemy_one:
			if enemy_position_one.visible:
				new_targets.append(selected_unit)
		if selected_unit == enemy_two:
			if enemy_position_two.visible:
				new_targets.append(selected_unit)
		if selected_unit == enemy_three:
			if enemy_position_three.visible:
				new_targets.append(selected_unit)
		if selected_unit == enemy_four:
			if enemy_position_four.visible:
				new_targets.append(selected_unit)
		if selected_unit == enemy_five:
			if enemy_position_five.visible:
				new_targets.append(selected_unit)
	var new_signal_key : int = EventBus.generate_signal_key()
	ConsoleLog.SIGNAL(self,"unit_targets_selected","emit",new_signal_key)
	EventBus.unit_targets_selected.emit(new_targets,secondary_targets,new_signal_key)

func _on_enemy_team_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_one,enemy_two,enemy_three,enemy_four,enemy_five])

func _on_ally_team_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting(ally_team)

func _on_enemy_front_line_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_one,enemy_two,enemy_three])

func _on_enemy_back_line_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_four,enemy_five])

func _on_ally_front_line_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([ally_team[0],ally_team[1],ally_team[2]])

func _on_ally_back_line_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([ally_team[3],ally_team[4]])

func _on_enemy_left_flank_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_one,enemy_four])

func _on_enemy_right_flank_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_three,enemy_five])

func _on_ally_left_flank_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([ally_team[0],ally_team[3]])

func _on_ally_right_flank_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([ally_team[2],ally_team[4]])

func _on_enemy_area_one_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_one,enemy_two,enemy_four])

func _on_enemy_area_two_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_two,enemy_four,enemy_five])

func _on_enemy_area_three_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([enemy_two,enemy_three,enemy_five])

func _on_ally_area_one_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([ally_team[0],ally_team[1],ally_team[3]])

func _on_ally_area_two_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([ally_team[1],ally_team[3],ally_team[4]])

func _on_ally_area_three_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		interpret_complex_targeting([ally_team[1],ally_team[2],ally_team[4]])
