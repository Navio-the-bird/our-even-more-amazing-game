extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	show()
	animation_player.play("splash_screen")
	get_viewport().gui_disable_input = true

func _on_animation_player_current_animation_changed(anim_name: StringName) -> void:
	if anim_name != "splash_screen":
		get_viewport().gui_disable_input = false
		queue_free()
