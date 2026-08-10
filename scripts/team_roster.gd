extends Node

var team_captain : unit

var combat_team : Array[unit]

func put_unit_into_combat_team(new_unit : unit):
	if combat_team.size()<5:
		if not team_captain:
			team_captain = new_unit
		combat_team.append(new_unit)
	ConsoleLog.INFO(self,["team_captain","combat_team"],[team_captain,combat_team])
