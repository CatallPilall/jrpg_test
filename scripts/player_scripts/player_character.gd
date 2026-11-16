extends CharacterBody2D

# var inv_toggle : bool = false

var speed : int = 75

func _ready() -> void:
	ConsoleLog.SCENE(true)

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	# delta wird schon in move_and_slide verrechnet
	velocity = input_dir * speed

	move_and_slide()

# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("open_inventory") and not inv_toggle:
# 		ConsoleLog.INPUT("open_inventory", "pressed", [])
# 		# var new_inventory_hud : Control = SceneLoader.load_scene(SceneLoader.SCENE_TYPE.INVENTORY_MENU) as Control
# 		# ConsoleLog.DEBUG(self,"load_hud_scene : " + str(new_inventory_hud))
# 		SceneLoader.load_scene(self, "inventory_menu")
# 		SceneLoader.activate_scene(self, "inventory_menu")
# 		inv_toggle = true
# 	elif event.is_action_pressed("open_inventory") and inv_toggle:
# 		ConsoleLog.INPUT("open_inventory", "pressed", [])
# 		SceneLoader.deactivate_scene(self, "inventory_menu")
# 		inv_toggle = false
