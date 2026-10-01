extends Resource

class_name game_class

@export var game_class_name : String

enum enum_class_armour_type {HEAVY,MEDIUM,LIGHT}
@export var class_armour_type : enum_class_armour_type

@export var attribute_scaling : Dictionary[String,int] = {
	"strength":0,
	"agility":0,
	"intelligence":0,
	"vitality":0,
	"endurance":0,
	"luck":0
}

@export var class_stat_boost : Dictionary[String,float]

@export var attack_skill_variant : skill
@export var defense_skill_variant : skill

@export var bound_skill_line : skill_line
