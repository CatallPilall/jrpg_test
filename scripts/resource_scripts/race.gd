extends Resource

class_name race

@export var race_name : String

@export var innate_attributes : Dictionary[String,int] = {
	"strength":0,
	"agility":0,
	"intelligence":0,
	"vitality":0,
	"endurance":0,
	"luck":0
}

@export var innate_stat_boost : Dictionary[String,float]

@export var innate_skills : Array[skill]
