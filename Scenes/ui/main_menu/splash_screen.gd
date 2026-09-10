extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var ignore_splash_screen: bool = false

func _ready() -> void:
	if ignore_splash_screen:
		queue_free()
		return
	
	show()
	animation_player.play("splash_screen")
	#get_viewport().gui_disable_input = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		await create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 1).set_trans(Tween.TRANS_SINE).finished
		queue_free()
	return  # swallow all game input

func _on_animation_player_current_animation_changed(anim_name: StringName) -> void:
	if anim_name != "splash_screen":
		#get_viewport().gui_disable_input = false
		queue_free()
