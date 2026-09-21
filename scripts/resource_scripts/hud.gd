extends Resource
class_name HudData


@export var scene_file : PackedScene
@export var description : String = ""
@export var is_scene_type : SceneLoader.SCENE_TYPE = SceneLoader.SCENE_TYPE.HUD
@export var is_scene_subtype : SceneLoader.HUD_TYPE = SceneLoader.HUD_TYPE.NONE

var name : String
var id : int = -1
