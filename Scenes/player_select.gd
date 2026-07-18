extends Control

@export var katana_player_select: Button
@export var sniper_player_select: Button

signal SelectedSniperPlayer
signal SelectedKatanaPlayer

func _ready() -> void:
	katana_player_select.pressed.connect(SelectedKatanaPlayer.emit)
	sniper_player_select.pressed.connect(SelectedSniperPlayer.emit)
