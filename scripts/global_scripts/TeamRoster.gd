extends Node

var team_captain : unit

var combat_team : Array[unit]

var relics : Array[item]
var consumables : Array[item]
var valuables : Array[item]

var logbook : Array[quest]

func _ready() -> void:
	var first_quest : quest = preload("res://resources/quests/dummy_quest_one.tres")
	var second_quest : quest = preload("res://resources/quests/dummy_quest_two.tres")
	var third_quest : quest = preload("res://resources/quests/dummy_quest_three.tres")
	put_quest_into_logbook(first_quest)
	put_quest_into_logbook(second_quest)
	put_quest_into_logbook(third_quest)

func put_unit_into_combat_team(new_unit : unit):
	if combat_team.size()<5:
		if not team_captain:
			team_captain = new_unit
		combat_team.append(new_unit)
	ConsoleLog.INFO(["team_captain","combat_team"],[team_captain,combat_team])

func put_item_into_inventory(new_item : item):
	var duped_item : item = new_item.duplicate()

	if new_item is consumable:
		consumables.append(duped_item)

func put_quest_into_logbook(new_quest : quest):
	logbook.append(new_quest)
