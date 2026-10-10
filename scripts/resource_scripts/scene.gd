extends Resource
class_name SceneData

@export var scene_file : PackedScene
@export var description : String
@export var is_scene_type : SceneDB.SCENE_TYPE


var scene_name : String
var id : int = -1


var node_is_loaded : bool = false

var instantiated_node : Node = null:
	set(value):
		instantiated_node = value
		if instantiated_node != null:
			node_is_loaded = true
		else:
			node_is_loaded = false

var node_is_active : bool = false

var node_is_paused : bool = false:
	set(value):
		if instantiated_node != null and node_is_active:
			if value:
				instantiated_node.pause_mode = Node.PROCESS_MODE_INHERIT
			else:
				instantiated_node.pause_mode = Node.PROCESS_MODE_DISABLED
			node_is_paused = value
		else:
			ConsoleLog.WARNING("Cannot set node_is_paused for scene: " + scene_name + " because the node is not instantiated or not active.")

var node_is_hidden : bool = false:
	set(value):
		if instantiated_node != null and node_is_active:
			if value:
				instantiated_node.hide()
			else:
				instantiated_node.show()
			node_is_hidden = value
		else:
			ConsoleLog.WARNING("Cannot set node_is_paused for scene: " + scene_name + " because the node is not instantiated or not active.")
