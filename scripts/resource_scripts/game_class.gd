extends Resource

class_name game_class

@export var game_class_name : String

enum enum_class_armour_type {HEAVY,MEDIUM,LIGHT}
@export var class_armour_type : enum_class_armour_type

enum enum_class_weapon_type {SLASH,PIERCE,BLUD}
@export var class_weapon_type : enum_class_weapon_type

@export var class_stat_boost : Dictionary[String,float]

@export var attack_skill_variant : skill
@export var defense_skill_variant : skill

@export var bound_skill_line : skill_line
