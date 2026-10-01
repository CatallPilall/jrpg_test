extends Resource

class_name skill_line

@export var skill_line_name : String

var skill_line_level : int = 10

@export var skill_line_statboost : Dictionary[String, float]

@export var skill_line_bound_skill : Dictionary[skill,int]

# Function for testing purpose -----------------------------------------
func add_bound_skills_to_unit(my_unit : unit):
	for skill_in_skill_line : skill in skill_line_bound_skill:
		if skill_line_level >= skill_line_bound_skill[skill_in_skill_line]:
			my_unit.unit_skills.append(skill_in_skill_line)
# ----------------------------------------------------------------------

func level_up_skill_line(my_unit):
	skill_line_level = skill_line_level + 1
	
	for skill_in_skill_line : skill in skill_line_bound_skill:
		if skill_line_level == skill_line_bound_skill[skill_in_skill_line]:
			my_unit.unit_skills.append(skill_in_skill_line)
