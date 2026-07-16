extends Control
class_name PauseMenu

func _ready() -> void:
	self.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_menu()


func toggle_menu() -> void:
	if visible:
		self.hide()
		get_tree().paused = false
		ControlManager.enable_action_group(ControlManager.player_actions)
	else:
		self.show()
		get_tree().paused = true
		ControlManager.disable_action_group(ControlManager.player_actions)
