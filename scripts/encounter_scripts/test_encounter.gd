extends encounter

var enemy_one_packed_scene : PackedScene = preload("res://scenes/unit_scenes/unit_goblin_brute.tscn")

func _ready() -> void:
	ConsoleLog.SCENE(self,true)
	enemy_one = enemy_one_packed_scene.instantiate()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	initiate_combat()
