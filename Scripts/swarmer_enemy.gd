class_name SwarmerEnemy
extends BaseEnemy

@export var melee_attack_scene:PackedScene

func _ready() -> void:
	acceleration = 800

func attack() -> void:
	_attacking = true
	print('Swarmer attack!')
	_attacking = false
