extends Resource

class_name unit

@export var unit_sprite_path : String
@export var unit_name : String
@export var unit_level : int

@export var attributes : Dictionary[String,int] = {
	"strength":0,
	"agility":0,
	"intelligence":0,
	"vitality":0,
	"endurance":0,
	"luck":0
}

@export var attributes_per_level : Dictionary[String,int] = {
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
	"phys_def":0,
	"pierce_def":0,
	"slash_def":0,
	"blud_def":0,
	"accuracy":0,
	"evasion":0,
	"crit_chance":0,
	"crit_efficiency":0,
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
	"lucky_chance":0
}

var active_stats : Dictionary[String,float] = {
	"health_points":0,
	"speed":0,
	"status_def":0,
	"phys_atk":0,
	"phys_def":0,
	"pierce_def":0,
	"slash_def":0,
	"blud_def":0,
	"accuracy":0,
	"evasion":0,
	"crit_chance":0,
	"crit_efficiency":0,
	"status_damage":0,
	"magic_atk":0,
	"magic_def":0,
	"fire_def":0,
	"elec_def":0,
	"ice_def":0,
	"fire_efficiency":100,
	"elec_efficiency":0,
	"ice_efficiency":0,
	"backfire_chance":0,
	"poof_chance":0,
	"overcast_chance":0,
	"poi_def":0,
	"poi_efficiency":0,
	"lucky_chance":0
}

@export var unit_skills : Dictionary[String,int] = {
	"fireball":0}
