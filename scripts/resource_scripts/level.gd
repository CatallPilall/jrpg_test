extends Resource
class_name LevelData

@export var level_description : String
@export var scene_file : PackedScene
@export var is_scene_type : SceneLoader.SCENE_TYPE = SceneLoader.SCENE_TYPE.LEVEL
@export var is_scene_subtype : SceneLoader.LEVEL_TYPE = SceneLoader.LEVEL_TYPE.NONE

var name : String
var id : int = -1
