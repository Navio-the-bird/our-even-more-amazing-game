extends Control

@onready var audio_slider: HSlider = $CharacterMargin/GridContainer/Audio/AudioSlider
@onready var screen_mode_dropdown: OptionButton = $"CharacterMargin/GridContainer/Screen Mode/ScreenModeDropdown"

var default_volume: float = 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_slider.value_changed.connect(_on_option_button_value_changed)
	screen_mode_dropdown.item_selected.connect(_on_option_button_item_selected)
	
	audio_slider.value = default_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(default_volume))

func _on_option_button_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
