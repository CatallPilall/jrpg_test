extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

var inventory_hud_packed_scene : PackedScene = preload("res://scenes/UI_scenes/inventory_hud.tscn")

var speed : int = 5000

func _ready() -> void:
	ConsoleLog.SCENE(self, true)

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_dir * speed * delta
	
	if velocity == Vector2.ZERO:
		animation_tree["parameters/playback"].travel("idle")
	else:
		animation_tree.set("parameters/idle/blend_position",velocity)
		animation_tree.set("parameters/move/blend_position",velocity)
		animation_tree["parameters/playback"].travel("move")
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		ConsoleLog.INPUT("open_inventory","pressed",[])
		var new_inventory_hud : Control = inventory_hud_packed_scene.instantiate()
		var new_signal_key : int = EventBus.generate_signal_key()
		ConsoleLog.SIGNAL(self,"load_hud_scene","emit",new_signal_key)
		EventBus.load_hud_scene.emit(new_inventory_hud,new_signal_key)
