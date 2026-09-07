extends Button
class_name AnimatedButton

var hover_scale: Vector2 = Vector2(1.1, 1.1)
var pressed_scale: Vector2 = Vector2(0.9, 0.9)
var animation_duration: float = 0.1

@export var normal_text_color: Color = Color.GRAY
@export var hover_text_color: Color = Color.WHITE

@export var hover_additional_text: String

signal delayed_pressed

func _ready() -> void:
	offset_transform_enabled = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)
	set("theme_override_colors/font_color", normal_text_color)

func _on_mouse_entered() -> void:
	create_tween().tween_property(self, "offset_transform_scale", hover_scale, animation_duration).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(self, "theme_override_colors/font_color", hover_text_color, animation_duration)
#	create_tween().tween_property(self, "offset_transform_scale", hover_scale, animation_duration).set_trans(Tween.TRANS_SINE)
	text += hover_additional_text

func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "offset_transform_scale", Vector2.ONE, animation_duration).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(self, "theme_override_colors/font_color", normal_text_color, animation_duration)
#	create_tween().tween_property(self, "theme_override_colors/font_outline_color", normal_text_color, animation_duration).set_trans(Tween.TRANS_SINE)
	text = text.replace(hover_additional_text, "")

func _on_pressed() -> void:
	var button_pressed_tween: Tween = create_tween()
	button_pressed_tween.tween_property(self, "offset_transform_scale", pressed_scale, animation_duration * 0.6).set_trans(Tween.TRANS_SINE)
	button_pressed_tween.tween_property(self, "offset_transform_scale", hover_scale, animation_duration * 1.2).set_trans(Tween.TRANS_SINE)
	await button_pressed_tween.finished
	delayed_pressed.emit()
