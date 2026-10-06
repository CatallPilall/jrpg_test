extends Resource

class_name unit

@export var unit_sprite_path : String
@export var unit_name : String
@export var unit_level : int

@export var unit_race : race:
	set(value):
		unit_race = value
		ConsoleLog.DEBUG("unit_race: " + str(unit_race))
		set_unit_attributes()

@export var unit_class : game_class:
	set(value):
		unit_class = value
		ConsoleLog.DEBUG("unit_class: " + str(unit_class))
		set_unit_attributes()
		copy_unit_skills_from_class()

var unit_skillpoints : int

var attributes : Dictionary[String,int] = {
	"strength":0,
	"agility":0,
	"intelligence":0,
	"vitality":0,
	"endurance":0,
	"luck":0
}

var base_stats : Dictionary[String,float] = {
	"health_points":0,
	"speed":0,
	"status_def":0,
	"phys_atk":0,
	"fire_atk":0,
	"elec_atk":0,
	"ice_atk":0,
	"phys_def":0,
	"pierce_def":0,
	"slash_def":0,
	"blud_def":0,
	"accuracy":0,
	"evasion":0,
	"crit_chance":0,
	"crit_efficiency":0,
	"crit_def":0,
	"status_damage":0,
	"magic_atk":0,
	"magic_def":0,
	"fire_def":0,
	"elec_def":0,
	"ice_def":0,
	"fire_efficiency":0,
	"elec_efficiency":0,
	"ice_efficiency":0,
	"backfire_chance":0,
	"poof_chance":0,
	"overcast_chance":0,
	"poi_def":0,
	"poi_efficiency":0,
	"curse_efficiency":0,
	"buff_efficiency":0,
	"healing_efficiency":0,
	"resilience":0,
	"lucky_chance":0
}

var active_stats : Dictionary[String,float] = {}

func duplicate_base_stats_into_active_stats():
	active_stats = base_stats.duplicate()

func clear_active_stats_dictionary():
	active_stats.clear()

var bleed_dots : Array[skill_fragment]
var poison_dots : Array[skill_fragment]
var curses : Array[skill_fragment]

var weapon_buff : Array[skill_fragment]
var body_buff : Array[skill_fragment]
var aura_buff : Array[skill_fragment]
var blessing : Array[skill_fragment]
var stance : Array[skill_fragment]

var disarm : Array[skill_fragment]
var silence : Array[skill_fragment]
var root : Array[skill_fragment]
var sleep : Array[skill_fragment]
var stun : Array[skill_fragment]
var paralyze : Array[skill_fragment]

var unit_skill_lines : Array[skill_line]

var unit_attack_skill : skill
var unit_defense_skill : skill
var unit_skills : Array[skill]

func set_unit_attributes():
	if unit_class and unit_race:
		for selected_attribute : String in attributes:
			ConsoleLog.INFO(["innate_attributes"],[unit_race.innate_attributes])
			ConsoleLog.DEBUG("Looking for key: " + selected_attribute + " | Exists: " + str(unit_race.innate_attributes.has(selected_attribute)))
			var new_value : int = unit_race.innate_attributes.get(selected_attribute) + unit_level * unit_class.attribute_scaling.get(selected_attribute)
			attributes.set(selected_attribute,new_value)
		
		scale_base_stats()
		apply_race_and_class_innate_stats()

func scale_base_stats():
	var strength_scaling : int = attributes.get("strength")
	var agility_scaling : int = attributes.get("agility")
	var intelligence_scaling : int = attributes.get("intelligence")
	var vitality_scaling : int = attributes.get("vitality")
	var endurance_scaling : int = attributes.get("endurance")
	var luck_scaling : int = attributes.get("luck")
	
	set_base_stat("phys_atk",strength_scaling * 1.7)
	set_base_stat("status_damage",strength_scaling * 0.5)
	set_base_stat("accuracy",agility_scaling * 0.3)
	set_base_stat("speed",agility_scaling * 0.2)
	set_base_stat("magic_atk",intelligence_scaling * 1.4)
	set_base_stat("magic_def",intelligence_scaling * 0.8)
	set_base_stat("health_points",vitality_scaling * 2.2)
	set_base_stat("phys_def",vitality_scaling * 1.1)
	set_base_stat("status_def",endurance_scaling * 1.2)
	set_base_stat("crit_def", endurance_scaling * 0.2)
	set_base_stat("crit_chance",luck_scaling * 0.6)
	set_base_stat("lucky_chance", luck_scaling * 0.1)

func apply_race_and_class_innate_stats():
	for selected_stat : String in unit_race.innate_stat_boost:
		var stat_value : float = unit_race.innate_stat_boost.get(selected_stat)
		set_base_stat(selected_stat,stat_value)
	
	for selected_stat : String in unit_class.class_stat_boost:
		var stat_value : float = unit_class.class_stat_boost.get(selected_stat)
		set_base_stat(selected_stat,stat_value)

func set_base_stat(stat : String, value : float):
	var stat_buffer : float = 0
	stat_buffer = base_stats.get(stat)
	base_stats.set(stat,value + stat_buffer)

func copy_unit_skills_from_class():
	if unit_class:
		unit_attack_skill = unit_class.attack_skill_variant
		unit_defense_skill = unit_class.defense_skill_variant
		
		unit_skill_lines.append(unit_class.bound_skill_line)
		copy_unit_skills_from_skill_lines()

func copy_unit_skills_from_skill_lines():
	for selected_skill_line : skill_line in unit_skill_lines:
		selected_skill_line.add_bound_skills_to_unit(self)
