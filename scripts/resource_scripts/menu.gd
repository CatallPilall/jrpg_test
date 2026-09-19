extends Resource
class_name MenuData


@export var scene_file : PackedScene
@export var description : String = ""
@export var is_scene_type : SceneLoader.SCENE_TYPE = SceneLoader.SCENE_TYPE.MENU
@export var is_scene_subtype : SceneLoader.MENU_TYPE = SceneLoader.MENU_TYPE.NONE

var name : String
var id : int = -1
