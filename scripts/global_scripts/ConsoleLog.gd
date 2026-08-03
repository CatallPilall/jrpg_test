extends Node

enum output_type{MESSAGE,DEBUG,INFO,ERROR,SIGNAL,INPUT,SCENE}

func MESSAGE(messenger : Object, text : String):
	var new_message : String = JSON.stringify(messenger) + " : " + text
	write(output_type.MESSAGE,new_message)

func SIGNAL(messenger : Object, affected_signal : String, signal_message : String, signal_key : int):
	var new_message = JSON.stringify(messenger) + " : " + affected_signal + " " + signal_message + " (" + str(signal_key) +")"
	write(output_type.SIGNAL, new_message)

func DEBUG(messenger : Object, text : String):
	var new_message : String = JSON.stringify(messenger) + " : " + text
	write(output_type.DEBUG,new_message)

func ERROR(messenger : Object, script_and_row : String, text : String):
	var new_message : String = JSON.stringify(messenger) + " at: " + script_and_row + " " + text
	write(output_type.ERROR,new_message)

func INFO(messenger : Object, variable_names : Array[String], variable_values : Array):
	var array_string : String = ""
	
	if variable_names.size() == variable_values.size():
		for i in range(variable_names.size()):
			array_string += "\n" + variable_names[i] + " : " + JSON.stringify(variable_values[i], "\t")
		
		var new_message : String = JSON.stringify(messenger) + " : " + array_string
		
		write(output_type.INFO, new_message)
	else:
		ERROR(messenger,"ConsoleLog :32","ConsoleLog STATUS names and values Arrays not of equal size")

func SCENE(messenger : Node, status : bool):
	
	var string_status : String
	
	if status:
		string_status = "entered"
	else:
		string_status = "exited"
	
	var new_message :String = JSON.stringify(messenger) + " " + string_status + " scene tree"
	write(output_type.SCENE,new_message)

func INPUT(input_type : String, input_action : String, additional_info : Array):
	var array_string : String = ""
	
	if not additional_info.is_empty():
		for i in additional_info:
			array_string += "\n" + JSON.stringify(i) + ", "
	
	var new_message : String = input_type + " " + input_action + array_string
	
	write(output_type.INPUT, new_message)

func write(type : output_type, message : String):
	var time : String = Time.get_time_string_from_system()
	var prefix_text : String = ""
	var color : String = ""
	
	match type:
		output_type.MESSAGE:
			prefix_text = "[MESSAGE]"
			color = "white"
		output_type.SIGNAL:
			prefix_text = "[SIGNAL]"
			color = "grey"
		output_type.DEBUG:
			prefix_text = "[DEBUG]"
			color = "yellow"
		output_type.ERROR:
			prefix_text = "[ERROR]"
			color = "red"
		output_type.INFO:
			prefix_text = "[INFO]"
			color = "magenta"
		output_type.INPUT:
			prefix_text = "[INPUT]"
			color = "cyan"
		output_type.SCENE:
			prefix_text = "[SCENE]"
			color = "dark green"
	
	var header : String = "%s [%s] " % [prefix_text, time]
	var lines : PackedStringArray = message.split("\n")
	var final_output : String = ""
	
	for i : int in range(lines.size()):
		if i == lines.size() -1 and lines[i] == "":
			continue
		if i == 0:
			final_output += "[color=%s]%s%s[/color]" % [color, header, lines[i]]
		else:
			var indent : String = " ".repeat(header.length())
			final_output += "\n[color=%s]%s%s[/color]" % [color, indent, lines[i]]
	print_rich("\n", final_output)
