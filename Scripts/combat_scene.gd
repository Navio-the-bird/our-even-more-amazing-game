extends Node2D

@export var player:Player
@export var pause_menu:PauseMenu
var towers:Array[EnemyTower] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.death.connect(_on_player_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_death():
	print('\n\nI am aware that the player has died, yes\n')
	pause_menu.toggle_menu()
