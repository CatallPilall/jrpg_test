extends Node

var team_captain : unit

var combat_team : Array[unit]

var relics : Array[item]
var consumables : Array[item]
var valuables : Array[item]

func put_unit_into_combat_team(new_unit : unit):
	if combat_team.size()<5:
		if not team_captain:
			team_captain = new_unit
		combat_team.append(new_unit)
	ConsoleLog.INFO(self,["team_captain","combat_team"],[team_captain,combat_team])

func put_item_into_inventory(new_item : item):
	var duped_item : item = new_item.duplicate()
	match new_item.item_type:
		item.enum_item_type.CONSUMABLE:
			consumables.append(duped_item)
		item.enum_item_type.RELIC:
			relics.append(duped_item)
		item.enum_item_type.VALUABLE:
			valuables.append(duped_item)
