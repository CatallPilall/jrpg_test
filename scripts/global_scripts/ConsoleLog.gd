extends Node

enum output_type { MESSAGE, DEBUG, INFO, WARNING, ERROR, SIGNAL, INPUT, SCENE }

# --- LOG-METHODEN ---

func MESSAGE(text: String) -> void:
	var new_message: String = _caller_and_line() + text
	write(output_type.MESSAGE, new_message)

func SIGNAL(affected_signal: Signal, signal_message: String, signal_key: int) -> void:
	var new_message: String = _caller_and_line() + affected_signal.get_name() + " " + signal_message + " (" + str(signal_key) + ")"
	write(output_type.SIGNAL, new_message)

func DEBUG(text: String) -> void:
	var new_message: String = _caller_and_line() + text
	write(output_type.DEBUG, new_message)

func ERROR(text: String) -> void:
	var new_message: String = _caller_and_line() + text
	write(output_type.ERROR, new_message)

func WARNING(text: String) -> void:
	var new_message: String = _caller_and_line() + text
	write(output_type.WARNING, new_message)

func INFO(variable_names: Array[String], variable_values: Array) -> void:
	var array_string: String = ""

	if variable_names.size() == variable_values.size():
		for i in range(variable_names.size()):
			array_string += "\n" + variable_names[i] + " : " + JSON.stringify(variable_values[i], "\t")

		var new_message: String = _caller_and_line() + array_string
		write(output_type.INFO, new_message)
	else:
		ERROR("ConsoleLog STATUS names and values Arrays not of equal size")

func SCENE(status: bool) -> void:
	var string_status: String = "entered" if status else "exited"
	var new_message: String = _caller_and_line() + string_status + " scene tree"
	write(output_type.SCENE, new_message)

func INPUT(input_type: String, input_action: String, additional_info: Array = []) -> void:
	var array_string: String = ""
	if not additional_info.is_empty():
		for i in additional_info:
			array_string += "\n" + JSON.stringify(i) + ", "

	var new_message: String = _caller_and_line() + input_type + " " + input_action + array_string
	write(output_type.INPUT, new_message)



# Helfer funktionen --------------------------------------------------------
func _caller_and_line() -> String:
	var caller_info: String = _get_caller_info()
	return "[" + caller_info + "]: "


# --- HELFER-FUNKTION FÜR CALL-STACK (Zeile + Funktion) ---
func _get_caller_info() -> String:
	var stack: Array = get_stack()
	# Index 0 = _get_caller_info()
	# Index 1 = _caller_and_line()
	# Index 2 = Logger-Methode (z. B. DEBUG, ERROR)
	# Index 3 = Das Skript, das den Logger aufgerufen hat
	if stack.size() > 3:
		var caller: Dictionary = stack[3]
		var file_name: String = String(caller.get("source", "")).get_file()
		var line_num: int = caller.get("line", 0)
		var func_name: String = caller.get("function", "")

		return "%s:%d in %s()" % [file_name, line_num, func_name]
	return "unknown:0"
# --------------------------------------------------------------------------




# --- DRUCK-OUTPUT ---

func write(type: output_type, message: String) -> void:
	var time: String = Time.get_time_string_from_system()
	var prefix_text: String = ""
	var color: String = ""

	match type:
		output_type.MESSAGE:
			prefix_text = "[MESSAGE]"
			color = "white"
		output_type.SIGNAL:
			prefix_text = "[SIGNAL]"
			color = "gray"
		output_type.DEBUG:
			prefix_text = "[DEBUG]"
			color = "yellow"
		output_type.ERROR:
			prefix_text = "[ERROR]"
			color = "red"
		output_type.WARNING:
			prefix_text = "[WARNING]"
			color = "orange"
		output_type.INFO:
			prefix_text = "[INFO]"
			color = "magenta"
		output_type.INPUT:
			prefix_text = "[INPUT]"
			color = "cyan"
		output_type.SCENE:
			prefix_text = "[SCENE]"
			color = "dark_green"

	var header: String = "%s [%s] " % [prefix_text, time]
	var lines: PackedStringArray = message.split("\n")
	var final_output: String = ""

	for i: int in range(lines.size()):
		if i == lines.size() - 1 and lines[i] == "":
			continue
		if i == 0:
			final_output += "[color=%s]%s%s[/color]" % [color, header, lines[i]]
		else:
			var indent: String = " ".repeat(header.length())
			final_output += "\n[color=%s]%s%s[/color]" % [color, indent, lines[i]]

	print_rich("\n", final_output)
