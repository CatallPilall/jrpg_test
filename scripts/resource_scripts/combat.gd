extends Resource
class_name CombatData


@export var scene_file : PackedScene
@export var description : String = ""
@export var is_scene_type : SceneLoader.SCENE_TYPE = SceneLoader.SCENE_TYPE.COMBAT
@export var is_scene_subtype : SceneLoader.COMBAT_TYPE = SceneLoader.COMBAT_TYPE.NONE

var name : String
var id : int = -1
