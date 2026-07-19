extends Control
class_name PauseMenu

signal quit_game

func _ready() -> void:
	self.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_menu()


func toggle_menu() -> void:
	if visible:
		_unpause_game()
	else:
		_pause_game()

func _unpause_game():
	self.hide()
	get_tree().paused = false
	#ControlManager.enable_action_group(ControlManager.player_actions)
	
func _pause_game():
	if %MainMenu and %MainMenu.visible:
		return
	
	self.show()
	get_tree().paused = true
	#ControlManager.disable_action_group(ControlManager.player_actions)

func _on_quit_pressed() -> void:
	_unpause_game()
	quit_game.emit()
