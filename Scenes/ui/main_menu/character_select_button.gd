extends Button
class_name CharacterSelectButton

var hover_scale: Vector2 = Vector2(1.1, 1.1)
var pressed_scale: Vector2 = Vector2(0.9, 0.9)
var animation_duration: float = 0.1

signal delayed_pressed

var texture: TextureRect

func _ready() -> void:
	offset_transform_enabled = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)
	
	if not find_children("", "TextureRect").is_empty():
		texture = find_children("", "TextureRect")[0]
		texture.modulate = Color.DIM_GRAY

func _on_mouse_entered() -> void:
	create_tween().tween_property(self, "offset_transform_scale", hover_scale, animation_duration).set_trans(Tween.TRANS_SINE)
	if texture:
		texture.modulate = Color.WHITE

func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "offset_transform_scale", Vector2.ONE, animation_duration).set_trans(Tween.TRANS_SINE)
	if texture:
		texture.modulate = Color.DIM_GRAY

func _on_pressed() -> void:
	var button_pressed_tween: Tween = create_tween()
	button_pressed_tween.tween_property(self, "offset_transform_scale", pressed_scale, animation_duration * 0.6).set_trans(Tween.TRANS_SINE)
	button_pressed_tween.tween_property(self, "offset_transform_scale", hover_scale, animation_duration * 1.2).set_trans(Tween.TRANS_SINE)
	await button_pressed_tween.finished
	delayed_pressed.emit()
