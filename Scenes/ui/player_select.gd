extends Control

signal SelectedSniperPlayer
signal SelectedKatanaPlayer

func _ready() -> void:
	pass

func _select_katana_player():
	SelectedKatanaPlayer.emit()

func _select_sniper_player():
	SelectedSniperPlayer.emit()
