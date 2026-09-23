extends BaseLevel

@onready var path_2d_follow: PathFollow2D = $Path2D/PathFollow2D

@export var speed_path_following: float = 200.0 
var path_following_direction: int = 1 # 1 = vorwärts, -1 = rückwärts


func _ready() -> void:
	super._ready()
	ConsoleLog.SCENE(true)


func _process(delta: float) -> void:
	if path_2d_follow == null:
		return

	# 1. Bewegung auf der PathFollow2D-Node ausführen
	path_2d_follow.progress += speed_path_following * path_following_direction * delta
	
	# 2. Endpunkte prüfen und Richtung anpassen
	if path_2d_follow.progress_ratio >= 1.0:
		path_2d_follow.progress_ratio = 1.0
		path_following_direction = -1
	elif path_2d_follow.progress_ratio <= 0.0:
		path_2d_follow.progress_ratio = 0.0
		path_following_direction = 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	SceneLoader.load_scene(self, "next_level")
	SceneLoader.activate_scene(self, "next_level")
