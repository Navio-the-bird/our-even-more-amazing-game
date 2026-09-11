extends Control

func _ready() -> void:
	hide_all()
	%Main.show()

func _on_play_button_pressed() -> void:
	hide_all()
	%PlayerSelect.show()

func _on_options_button_delayed_pressed() -> void:
	hide_all()
	%Options.show()

func _on_back_button_pressed() -> void:
	hide_all()
	%Main.show()

func _on_credits_button_pressed() -> void:
	hide_all()
	%Credits.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func hide_all() -> void:
	%Main.hide()
	%PlayerSelect.hide()
	%Options.hide()
	%Credits.hide()
