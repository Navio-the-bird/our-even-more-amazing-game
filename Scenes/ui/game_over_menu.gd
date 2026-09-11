extends Control
class_name GameOverMenu

signal play_again
signal quit_game

@onready var title: RichTextLabel = $MarginContainer/Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var subtitle: RichTextLabel = $MarginContainer/Panel/MarginContainer/VBoxContainer/SubtitleLabel

@export_multiline var randomTexts: Array[String]

var victory_animation_time: float = 0.5

func _ready() -> void:
	subtitle.hide()
	self.hide()

func _unpause_game():
	self.hide()
	get_tree().paused = false

func game_over():
	if %MainMenu and %MainMenu.visible:
		return
	self.show()
	get_tree().paused = true

func victory():
	title.text = "VICTORY"
	subtitle.show()
	subtitle.text = randomTexts.pick_random()
	
	if %MainMenu and %MainMenu.visible:
		return
	
	offset_transform_scale = Vector2(0.25, 0.25)
	modulate = Color.TRANSPARENT
	self.show()
	
	create_tween().tween_property(self, "offset_transform_scale", Vector2.ONE, victory_animation_time).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(self, "modulate", Color.WHITE, victory_animation_time).set_trans(Tween.TRANS_SINE)


func _on_quit_pressed() -> void:
	_unpause_game()
	quit_game.emit()

func _on_play_again_button_delayed_pressed() -> void:
	_unpause_game()
	play_again.emit()
