class_name SwarmerEnemy
extends BaseEnemy

@export var melee_attack_scene:PackedScene

func _ready() -> void:
	acceleration = 800

func attack() -> void:
	print('Swarmer attack!')
