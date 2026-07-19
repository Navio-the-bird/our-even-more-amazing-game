extends Control

func _ready() -> void:
	%PlayerSelect.hide()
	%Main.show()
	%Credits.hide()
	#ControlManager.disable_action("pause")

func _on_play_button_pressed() -> void:
	%PlayerSelect.show()
	%Main.hide()
	%Credits.hide()

func _on_back_button_pressed() -> void:
	%PlayerSelect.hide()
	%Main.show()
	%Credits.hide()

func _on_credits_button_pressed() -> void:
	%PlayerSelect.hide()
	%Main.hide()
	%Credits.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
