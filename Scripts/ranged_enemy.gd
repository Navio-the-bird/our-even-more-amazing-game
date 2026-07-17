class_name RangedEnemy
extends BaseEnemy


func _ready() -> void:
	attack_distance = 2000 #Distance at which the enemy starts firing
	acceleration = 500

func attack() -> void:
	print('About to shoot, I guess')
