extends Control


@onready var timer_hud : Label = $time_hud_container/time_hud
@onready var fps_hud: Label = $fps_hud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect_function_with_signal(self, self._on_timer_updated, EventBus.timer_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	fps_hud.text = str(Engine.get_frames_per_second())


func _on_timer_updated(time_as_string : String, _signal_key : int) -> void:
	timer_hud.text = time_as_string
