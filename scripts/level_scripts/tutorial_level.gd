extends BaseLevel

@onready var path_2d_follow: PathFollow2D = $Path2D/PathFollow2D

@export var speed_path_following: float = 200.0
var path_following_direction: int = 1 # 1 = vorwärts, -1 = rückwärts

# random testing
var player_in_range: bool = false

func _ready() -> void:
	super._ready()
	ConsoleLog.SCENE(true)
	EventBus.connect_function_with_signal(self, _on_interact_pressed, EventBus.interact_pressed)


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


func _on_area_2d_area_entered(_area: Area2D) -> void:
	SceneLoader.process_scene("next_level", [], SceneLoader.SCENE_PROCESS_TYPE.ACTIVATE)


func _prepare_scene(called_node : Node, arguments : Array, signal_key : int):
	if called_node == self:
		ConsoleLog.DEBUG("HEHEO AUFGERUFEN IN TUTORIAL_LEVEL PREPARE_SCENE")
		super(called_node, arguments, signal_key)






# testzwecke
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		ConsoleLog.DEBUG("Player exited the Area2D!")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		ConsoleLog.DEBUG("Player entered the Area2D!")


func _on_interact_pressed(_signal_key : int) -> void:
	ConsoleLog.DEBUG("Interact pressed in tutorial_level.gd")
	if player_in_range:
		ConsoleLog.DEBUG("Interacted with this specific Area2D!")
		EventBus.emit_signal_log(EventBus.play_spatial_audio_effects)



# func _on_area_2d_area_entered_goth(area: Area2D) -> void:
# 	ConsoleLog.DEBUG("Area entered: " + area.get_name())
# 	if area.is_in_group("player"):
# 		player_in_range = true
# 		ConsoleLog.DEBUG("Player entered the Area2D!")
#
#
# func _on_area_2d_area_exited_goth(area: Area2D) -> void:
# 	ConsoleLog.DEBUG("Area exited: " + area.get_name())
# 	if area.is_in_group("player"):
# 		player_in_range = false
# 		ConsoleLog.DEBUG("Player exited the Area2D!")
