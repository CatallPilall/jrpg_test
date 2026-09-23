extends Node

var inv_toggle : bool = false
var pause_toggled : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# globale input events wie inventar und pause usw. sollten hier passieren;
# alle inputs, die vorher in den anderen scripts NICHT abgefangen werden,
# landen hier. Wenn die scripte vorher diese aber behandeln, wird es nicht hier abgefangen,
# außer die anderen scripte geben das event weiter als unbehandelt (siehe docs: man kann events als unbehandelt weitergeben)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory") and not inv_toggle:
		ConsoleLog.INPUT("toggle_inventory", "pressed", [])
		# var new_inventory_hud : Control = SceneLoader.load_scene(SceneLoader.SCENE_TYPE.INVENTORY_MENU) as Control
		# ConsoleLog.DEBUG(self,"load_hud_scene : " + str(new_inventory_hud))
		# SceneLoader.load_scene(self, "inventory_menu")
		SceneLoader.activate_scene(self, "inventory_menu")
		inv_toggle = true
	elif event.is_action_pressed("toggle_inventory") and inv_toggle:
		ConsoleLog.INPUT("toggle_inventory", "pressed", [])
		SceneLoader.deactivate_scene(self, "inventory_menu")
		inv_toggle = false
	elif event.is_action_pressed("toggle_pause") and not pause_toggled:
		ConsoleLog.INPUT("toggle_pause", "pressed", [])
		SceneLoader.activate_scene(self, "pause_menu")
		pause_toggled = true
	elif event.is_action_pressed("toggle_pause") and pause_toggled:
		ConsoleLog.INPUT("toggle_pause", "pressed", [])
		SceneLoader.deactivate_scene(self, "pause_menu")
		pause_toggled = false
