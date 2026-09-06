extends Control
class_name GameOverMenu

signal play_again
signal quit_game

@onready var title: RichTextLabel = $MarginContainer/Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var subtitle: RichTextLabel = $MarginContainer/Panel/MarginContainer/VBoxContainer/SubtitleLabel

@export_multiline var randomTexts: Array[String]

func _ready() -> void:
	subtitle.hide()
	self.hide()

func _unpause_game():
	self.hide()
	get_tree().paused = false

func game_over():
	show_menu()

func victory():
	title.text = "VICTORY"
	subtitle.show()
	subtitle.text = randomTexts.pick_random()
	show_menu()

func show_menu():
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
