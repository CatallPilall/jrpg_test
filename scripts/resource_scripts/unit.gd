extends Resource

class_name unit

@export var unit_sprite_path : String

@export var unit_name : String

@export var unit_health : int

@export var unit_atk : int
@export var unit_def : int

@export var unit_fire_resist : int

@export var unit_speed : int

@export var unit_skills : Dictionary[String,int] = {"fireball":0}
