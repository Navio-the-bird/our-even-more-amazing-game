extends Control
class_name GameOverMenu

signal play_again
signal quit_game

func _ready() -> void:
	self.hide()

func _unpause_game():
	self.hide()
	get_tree().paused = false

func game_over():
	if %MainMenu and %MainMenu.visible:
		return
	self.show()
	get_tree().paused = true

func _on_quit_pressed() -> void:
	_unpause_game()
	quit_game.emit()

func _on_play_again_button_delayed_pressed() -> void:
	_unpause_game()
	play_again.emit()
