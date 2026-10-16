extends Resource

class_name ai_action_decision

@export var bound_skill : skill

@export var turn_cooldown : int
var turn_cooldown_counter : int

@export var chance_to_be_chosen : int
@export var chance_growth_per_miss : int
var current_chance_to_proc : int

@export var dependant_unit : unit
@export var dependant_stat : skill_fragment.enum_stat_buff
@export var dependant_value : int

enum enum_operator {NONE,GREATER_THAN,LESS_THAN,IN_AREA}
@export var operator : enum_operator
@export var operator_area : int

func _init() -> void:
	turn_cooldown_counter = turn_cooldown
	current_chance_to_proc = chance_to_be_chosen

func made_decision() -> bool :
	var decision : bool = false
	
	if turn_cooldown >= 0:
		if current_chance_to_proc >= roll_d_hundret():
			decision = true
		else :
			current_chance_to_proc = current_chance_to_proc + chance_growth_per_miss
	
	
	return decision

func roll_d_hundret() -> int :
	return randi_range(1,100)
